import SwiftUI
import Photos

struct ContentView: View {
    @StateObject private var photoLibraryManager = PhotoLibraryManager()
    
    var body: some View {
        MainView(photoLibraryManager: photoLibraryManager)
    }
}

struct MainView: View {
    @ObservedObject var photoLibraryManager: PhotoLibraryManager
    @StateObject private var viewModel: PhotoViewModel
    
    init(photoLibraryManager: PhotoLibraryManager) {
        self.photoLibraryManager = photoLibraryManager
        _viewModel = StateObject(wrappedValue: PhotoViewModel(manager: photoLibraryManager))
    }
    
    var body: some View {
        ZStack {
            Color(hex: "0D0D0D").edgesIgnoringSafeArea(.all)
            
            switch photoLibraryManager.authorizationStatus {
            case .notDetermined:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            case .authorized, .limited:
                if photoLibraryManager.isLoading {
                    ProgressView("Loading Photos...")
                        .foregroundColor(.white)
                } else if photoLibraryManager.photos.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "camera")
                            .font(.system(size: 64))
                            .foregroundColor(.gray)
                        Text("Your library is empty 🎉")
                            .font(.system(.title2, design: .rounded).bold())
                            .foregroundColor(.white)
                    }
                } else {
                    mainSwipeUI
                }
            case .denied, .restricted:
                PermissionDeniedView()
            @unknown default:
                PermissionDeniedView()
            }
        }
        .onAppear {
            photoLibraryManager.requestAuthorization()
        }
        .onChange(of: photoLibraryManager.authorizationStatus) { status in
            if status == .authorized || status == .limited {
                photoLibraryManager.fetchPhotos()
            }
        }
        .fullScreenCover(isPresented: $viewModel.isFinished) {
            SummaryView(viewModel: viewModel)
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            if let error = viewModel.deletionError {
                Text(error.localizedDescription)
            } else {
                Text("Could not delete this photo. Please try again.")
            }
        }
    }
    
    private var mainSwipeUI: some View {
        VStack {
            // Top: App title & progress bar
            VStack(spacing: 10) {
                Text("PhotoSwipe")
                    .font(.system(.title2, design: .rounded).bold())
                    .foregroundColor(.white)
                
                if photoLibraryManager.authorizationStatus == .limited {
                    Text("You've granted limited access. Some photos may not appear.")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.orange)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                        
                        Rectangle()
                            .fill(Color(hex: "34C759"))
                            .frame(width: geometry.size.width * CGFloat(viewModel.progress))
                            .animation(.linear(duration: 0.2), value: viewModel.progress)
                    }
                }
                .frame(height: 4)
                .cornerRadius(2)
                .padding(.horizontal)
            }
            .padding(.top)
            
            Spacer()
            
            // Middle: PhotoCardView with ZStack
            ZStack {
                if viewModel.currentIndex + 1 < photoLibraryManager.photos.count {
                    let nextPhoto = photoLibraryManager.photos[viewModel.currentIndex + 1]
                    PhotoCardView(photo: nextPhoto, viewModel: viewModel, isTopCard: false)
                        .scaleEffect(0.95)
                        .blur(radius: 2)
                        .transition(.asymmetric(insertion: .opacity, removal: .identity))
                        .zIndex(0)
                }
                
                if let currentPhoto = viewModel.currentPhoto {
                    PhotoCardView(photo: currentPhoto, viewModel: viewModel, isTopCard: true)
                        .transition(.asymmetric(
                            insertion: .opacity,
                            removal: .move(edge: viewModel.lastDragDirection)
                        ))
                        .zIndex(1)
                        .id(currentPhoto.id)
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Bottom: ActionButtonsView
            ActionButtonsView(viewModel: viewModel)
                .padding(.bottom)
        }
    }
}
