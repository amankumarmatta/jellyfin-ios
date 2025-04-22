import Foundation

struct MediaItem: Identifiable, Codable {
    let id: String
    let name: String
    let type: MediaType
    let overview: String?
    let productionYear: Int?
    let runTimeTicks: Int64?
    let imageTags: ImageTags?
    let userData: UserData?
    
    var posterImageURL: URL? {
        guard let tag = imageTags?.primary else { return nil }
        return URL(string: "\(JellyfinViewModel.shared.serverURL)/Items/\(id)/Images/Primary?tag=\(tag)")
    }
    
    var backdropImageURL: URL? {
        guard let tag = imageTags?.backdrop else { return nil }
        return URL(string: "\(JellyfinViewModel.shared.serverURL)/Items/\(id)/Images/Backdrop?tag=\(tag)")
    }
}

struct ImageTags: Codable {
    let primary: String?
    let backdrop: String?
    let logo: String?
}

struct UserData: Codable {
    let isFavorite: Bool
    let playedPercentage: Double?
    let unplayedItemCount: Int?
}

enum MediaType: String, Codable {
    case movie = "Movie"
    case series = "Series"
    case episode = "Episode"
    case season = "Season"
    case boxSet = "BoxSet"
    case musicAlbum = "MusicAlbum"
    case musicArtist = "MusicArtist"
    case musicVideo = "MusicVideo"
    case folder = "Folder"
}

struct LibrarySection: Identifiable {
    let id = UUID()
    let name: String
    let items: [MediaItem]
} 