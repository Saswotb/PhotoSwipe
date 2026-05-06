import SwiftUI

struct SwipeOverlayView: View {
    var dragOffset: CGSize
    
    var body: some View {
        HStack {
            if dragOffset.width > 20 {
                Text("KEEP ✓")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "34C759"))
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: "34C759"), lineWidth: 4)
                    )
                    .rotationEffect(.degrees(-15))
                    .opacity(min(abs(dragOffset.width) / 100, 1.0))
                    .padding(.top, 40)
                    .padding(.leading, 20)
                Spacer()
            } else if dragOffset.width < -20 {
                Spacer()
                Text("DELETE ✗")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "FF3B30"))
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: "FF3B30"), lineWidth: 4)
                    )
                    .rotationEffect(.degrees(15))
                    .opacity(min(abs(dragOffset.width) / 100, 1.0))
                    .padding(.top, 40)
                    .padding(.trailing, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
