import SwiftUI

@main
struct JellyfinApp: App {
    @StateObject private var viewModel = JellyfinViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
} 