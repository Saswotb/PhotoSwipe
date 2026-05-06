import Foundation
import SwiftUI
import Photos

class PhotoViewModel: ObservableObject {
    @Published var currentIndex: Int = 0
    @Published var keptCount: Int = 0
    @Published var deletedCount: Int = 0
    @Published var isFinished: Bool = false
    @Published var dragOffset: CGSize = .zero
    @Published var lastDragDirection: Edge = .leading
    @Published var deletionError: Error?
    @Published var showError: Bool = false
    
    var manager: PhotoLibraryManager
    
    init(manager: PhotoLibraryManager) {
        self.manager = manager
    }
    
    var currentPhoto: PhotoItem? {
        guard currentIndex < manager.photos.count else { return nil }
        return manager.photos[currentIndex]
    }
    
    var progress: Double {
        return Double(currentIndex) / Double(max(manager.photos.count, 1))
    }
    
    func swipeLeft() {
        lastDragDirection = .leading
        guard let current = currentPhoto else { return }
        
        // Optimistically advance UI
        deletedCount += 1
        advanceIndex()
        triggerHaptic()
        
        Task {
            do {
                try await manager.deleteAsset(asset: current.asset)
            } catch {
                DispatchQueue.main.async {
                    self.deletionError = error
                    self.showError = true
                    // Revert the UI optimally
                    withAnimation {
                        self.deletedCount -= 1
                        self.currentIndex -= 1
                        self.isFinished = false
                        self.dragOffset = .zero
                    }
                }
            }
        }
    }
    
    func swipeRight() {
        lastDragDirection = .trailing
        keptCount += 1
        advanceIndex()
        triggerHaptic()
    }
    
    private func advanceIndex() {
        currentIndex += 1
        if currentIndex >= manager.photos.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.isFinished = true
            }
        }
    }
    
    private func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
