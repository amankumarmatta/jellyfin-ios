import Foundation
import Alamofire
import SwiftyJSON
import SDWebImage

class JellyfinViewModel: ObservableObject {
    static let shared = JellyfinViewModel()
    
    @Published var isAuthenticated = false
    @Published var serverURL = ""
    @Published var username = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    @Published var librarySections: [LibrarySection] = []
    @Published var recentlyAdded: [MediaItem] = []
    @Published var continueWatching: [MediaItem] = []
    @Published var favorites: [MediaItem] = []
    
    private var authToken: String?
    private var userId: String?
    private var imageCache = NSCache<NSString, UIImage>()
    
    private init() {
        setupImageCache()
    }
    
    private func setupImageCache() {
        imageCache.countLimit = 100
        SDImageCache.shared.config.maxMemoryCost = 100 * 1024 * 1024 // 100MB
    }
    
    func connectToServer() {
        isLoading = true
        errorMessage = nil
        
        // Validate server URL
        guard let serverURL = URL(string: serverURL) else {
            errorMessage = "Invalid server URL"
            isLoading = false
            return
        }
        
        // Authenticate with server
        let parameters: [String: String] = [
            "Username": username,
            "Pw": password
        ]
        
        AF.request("\(serverURL)/Users/AuthenticateByName",
                  method: .post,
                  parameters: parameters,
                  encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: AuthenticationResponse.self) { [weak self] response in
                guard let self = self else { return }
                
                self.isLoading = false
                
                switch response.result {
                case .success(let authResponse):
                    self.authToken = authResponse.accessToken
                    self.userId = authResponse.user.id
                    self.isAuthenticated = true
                    self.fetchLibraryData()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
    }
    
    func fetchLibraryData() {
        guard let userId = userId, let authToken = authToken else { return }
        
        let headers: HTTPHeaders = [
            "X-Emby-Token": authToken
        ]
        
        // Fetch recently added
        AF.request("\(serverURL)/Users/\(userId)/Items/Latest",
                  parameters: ["Limit": 20],
                  headers: headers)
            .responseDecodable(of: [MediaItem].self) { [weak self] response in
                if let items = response.value {
                    self?.recentlyAdded = items
                }
            }
        
        // Fetch continue watching
        AF.request("\(serverURL)/Users/\(userId)/Items/Resume",
                  parameters: ["Limit": 20],
                  headers: headers)
            .responseDecodable(of: [MediaItem].self) { [weak self] response in
                if let items = response.value {
                    self?.continueWatching = items
                }
            }
        
        // Fetch favorites
        AF.request("\(serverURL)/Users/\(userId)/Items",
                  parameters: ["Filters": "IsFavorite", "Limit": 20],
                  headers: headers)
            .responseDecodable(of: [MediaItem].self) { [weak self] response in
                if let items = response.value {
                    self?.favorites = items
                }
            }
        
        // Fetch library sections
        AF.request("\(serverURL)/Users/\(userId)/Views",
                  headers: headers)
            .responseDecodable(of: [MediaItem].self) { [weak self] response in
                if let items = response.value {
                    self?.librarySections = items.map { item in
                        LibrarySection(name: item.name, items: [])
                    }
                    
                    // Fetch items for each section
                    for (index, section) in self?.librarySections ?? [] {
                        AF.request("\(self?.serverURL ?? "")/Users/\(userId)/Items",
                                 parameters: ["ParentId": section.id],
                                 headers: headers)
                            .responseDecodable(of: [MediaItem].self) { response in
                                if let items = response.value {
                                    self?.librarySections[index].items = items
                                }
                            }
                    }
                }
            }
    }
    
    func logout() {
        authToken = nil
        userId = nil
        isAuthenticated = false
        serverURL = ""
        username = ""
        password = ""
        librarySections = []
        recentlyAdded = []
        continueWatching = []
        favorites = []
        imageCache.removeAllObjects()
    }
}

struct AuthenticationResponse: Codable {
    let accessToken: String
    let user: User
    
    struct User: Codable {
        let id: String
        let name: String
    }
} 