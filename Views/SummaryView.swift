import SwiftUI

struct SummaryView: View {
    @ObservedObject var viewModel: PhotoViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(Color(hex: "34C759"))
                .padding(.top, 40)
            
            Text("All Done!")
                .font(.system(.largeTitle, design: .rounded).bold())
                .foregroundColor(.white)
            
            HStack(spacing: 20) {
                StatCard(title: "Kept", count: viewModel.keptCount, color: Color(hex: "34C759"))
                StatCard(title: "Deleted", count: viewModel.deletedCount, color: Color(hex: "FF3B30"))
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            Button(action: {
                viewModel.currentIndex = 0
                viewModel.keptCount = 0
                viewModel.deletedCount = 0
                viewModel.isFinished = false
                dismiss()
            }) {
                Text("Start Over")
                    .font(.system(.headline, design: .rounded).bold())
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "0D0D0D"))
    }
}

struct StatCard: View {
    var title: String
    var count: Int
    var color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.system(.headline, design: .rounded))
                .foregroundColor(.gray)
            
            Text("\(count)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
    }
}
