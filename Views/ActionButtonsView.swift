import SwiftUI

struct ActionButtonsView: View {
    @ObservedObject var viewModel: PhotoViewModel
    
    var body: some View {
        HStack(spacing: 40) {
            Button(action: {
                withAnimation(.easeOut(duration: 0.3)) {
                    viewModel.swipeLeft()
                }
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 64, height: 64)
                    .background(Circle().fill(Color(hex: "FF3B30")))
                    .shadow(color: Color(hex: "FF3B30").opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .buttonStyle(ScaleButtonStyle())
            
            Text("\(min(viewModel.currentIndex + 1, max(viewModel.manager.photos.count, 1))) / \(max(viewModel.manager.photos.count, 1))")
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            Button(action: {
                withAnimation(.easeOut(duration: 0.3)) {
                    viewModel.swipeRight()
                }
            }) {
                Image(systemName: "checkmark")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 64, height: 64)
                    .background(Circle().fill(Color(hex: "34C759")))
                    .shadow(color: Color(hex: "34C759").opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .buttonStyle(ScaleButtonStyle())
        }
        .padding(.vertical, 20)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
