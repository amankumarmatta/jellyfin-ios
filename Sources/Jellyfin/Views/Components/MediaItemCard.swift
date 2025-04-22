import SwiftUI
import SDWebImageSwiftUI

struct MediaItemCard: View {
    let item: MediaItem
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Poster Image
            WebImage(url: item.posterImageURL)
                .resizable()
                .placeholder {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.2))
                        .overlay(
                            Image(systemName: "film")
                                .foregroundColor(.gray)
                        )
                }
                .aspectRatio(2/3, contentMode: .fill)
                .frame(height: 200)
                .cornerRadius(12)
                .shadow(radius: 5)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            
            // Title
            Text(item.name)
                .font(.headline)
                .lineLimit(2)
                .foregroundColor(.primary)
            
            // Year and Type
            HStack {
                if let year = item.productionYear {
                    Text(String(year))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text(item.type.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(4)
            }
            
            // Progress Bar
            if let progress = item.userData?.playedPercentage {
                ProgressView(value: progress, total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .frame(height: 4)
            }
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .onTapGesture {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }
    }
}

struct MediaItemRow: View {
    let item: MediaItem
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Poster Image
            WebImage(url: item.posterImageURL)
                .resizable()
                .placeholder {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.2))
                        .overlay(
                            Image(systemName: "film")
                                .foregroundColor(.gray)
                        )
                }
                .aspectRatio(2/3, contentMode: .fill)
                .frame(width: 80, height: 120)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .lineLimit(2)
                
                if let year = item.productionYear {
                    Text(String(year))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let progress = item.userData?.playedPercentage {
                    ProgressView(value: progress, total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 4)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onTapGesture {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }
    }
} 