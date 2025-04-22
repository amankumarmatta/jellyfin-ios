import SwiftUI
import SDWebImageSwiftUI

struct MediaDetailView: View {
    let item: MediaItem
    @Environment(\.presentationMode) var presentationMode
    @State private var scrollOffset: CGFloat = 0
    @State private var isPlaying = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero Image
                GeometryReader { geometry in
                    let offset = geometry.frame(in: .global).minY
                    let height = geometry.size.height
                    
                    WebImage(url: item.backdropImageURL)
                        .resizable()
                        .placeholder {
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.2))
                        }
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: height + (offset > 0 ? offset : 0))
                        .clipped()
                        .offset(y: -offset)
                        .onChange(of: offset) { newValue in
                            scrollOffset = newValue
                        }
                }
                .frame(height: 300)
                
                // Content
                VStack(alignment: .leading, spacing: 16) {
                    // Title and Play Button
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.name)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            if let year = item.productionYear {
                                Text(String(year))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            isPlaying = true
                        }) {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("Play")
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    
                    // Overview
                    if let overview = item.overview {
                        Text(overview)
                            .font(.body)
                            .lineSpacing(4)
                    }
                    
                    // Additional Info
                    VStack(alignment: .leading, spacing: 8) {
                        InfoRow(title: "Type", value: item.type.rawValue)
                        
                        if let runtime = item.runTimeTicks {
                            let minutes = Int(runtime / 600000000)
                            let hours = minutes / 60
                            let remainingMinutes = minutes % 60
                            let runtimeString = "\(hours)h \(remainingMinutes)m"
                            InfoRow(title: "Runtime", value: runtimeString)
                        }
                    }
                    .padding(.top)
                }
                .padding()
                .background(Color(.systemBackground))
                .offset(y: -50)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Toggle favorite
                }) {
                    Image(systemName: item.userData?.isFavorite == true ? "heart.fill" : "heart")
                        .foregroundColor(item.userData?.isFavorite == true ? .red : .primary)
                }
            }
        }
        .fullScreenCover(isPresented: $isPlaying) {
            // Video Player View
            Text("Video Player")
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
        }
    }
}

struct MediaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MediaDetailView(item: MediaItem(
                id: "1",
                name: "Sample Movie",
                type: .movie,
                overview: "This is a sample movie overview that describes the plot and other details about the movie.",
                productionYear: 2023,
                runTimeTicks: 72000000000,
                imageTags: ImageTags(primary: "tag1", backdrop: "tag2", logo: nil),
                userData: UserData(isFavorite: true, playedPercentage: 50, unplayedItemCount: nil)
            ))
        }
    }
} 