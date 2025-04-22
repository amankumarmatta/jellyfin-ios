import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var viewModel: JellyfinViewModel
    @State private var selectedSection: LibrarySection?
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Continue Watching Section
                    if !viewModel.continueWatching.isEmpty {
                        SectionView(
                            title: "Continue Watching",
                            items: viewModel.continueWatching,
                            style: .horizontal
                        )
                    }
                    
                    // Recently Added Section
                    if !viewModel.recentlyAdded.isEmpty {
                        SectionView(
                            title: "Recently Added",
                            items: viewModel.recentlyAdded,
                            style: .horizontal
                        )
                    }
                    
                    // Favorites Section
                    if !viewModel.favorites.isEmpty {
                        SectionView(
                            title: "Favorites",
                            items: viewModel.favorites,
                            style: .horizontal
                        )
                    }
                    
                    // Library Sections
                    ForEach(viewModel.librarySections) { section in
                        SectionView(
                            title: section.name,
                            items: section.items,
                            style: .grid
                        )
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Library")
            .searchable(text: $searchText, prompt: "Search your library")
            .refreshable {
                viewModel.fetchLibraryData()
            }
        }
    }
}

struct SectionView: View {
    let title: String
    let items: [MediaItem]
    let style: SectionStyle
    
    enum SectionStyle {
        case horizontal
        case grid
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            if style == .horizontal {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(items) { item in
                            MediaItemCard(item: item)
                                .frame(width: 160)
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 16) {
                    ForEach(items) { item in
                        MediaItemCard(item: item)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
            .environmentObject(JellyfinViewModel.shared)
    }
} 