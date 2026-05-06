import SwiftUI

struct PhotoCardView: View {
    let photo: PhotoItem
    @ObservedObject var viewModel: PhotoViewModel
    var isTopCard: Bool
    @State private var image: UIImage? = nil
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let uiImage = image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "0D0D0D"))
                        .overlay(ProgressView())
                }
                
                if isTopCard {
                    SwipeOverlayView(dragOffset: viewModel.dragOffset)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            .offset(isTopCard ? viewModel.dragOffset : .zero)
            .rotationEffect(.degrees(isTopCard ? viewModel.dragOffset.width / 20 : 0))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if isTopCard {
                            viewModel.dragOffset = gesture.translation
                        }
                    }
                    .onEnded { gesture in
                        if isTopCard {
                            if gesture.translation.width < -100 {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    viewModel.swipeLeft()
                                    viewModel.dragOffset = .zero
                                }
                            } else if gesture.translation.width > 100 {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    viewModel.swipeRight()
                                    viewModel.dragOffset = .zero
                                }
                            } else {
                                withAnimation(.interactiveSpring()) {
                                    viewModel.dragOffset = .zero
                                }
                            }
                        }
                    }
            )
            .animation(.interactiveSpring(), value: isTopCard ? viewModel.dragOffset : .zero)
        }
        .task {
            let size = CGSize(width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height * 2)
            if let loadedImage = await viewModel.manager.loadThumbnail(for: photo.asset, size: size) {
                self.image = loadedImage
            }
        }
    }
}
