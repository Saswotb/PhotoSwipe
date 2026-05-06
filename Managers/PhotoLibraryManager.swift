import Foundation
import Photos
import UIKit

class PhotoLibraryManager: ObservableObject {
    @Published var authorizationStatus: PHAuthorizationStatus = .notDetermined
    @Published var photos: [PhotoItem] = []
    @Published var isLoading: Bool = false
    
    private let imageManager = PHImageManager.default()
    
    func requestAuthorization() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            DispatchQueue.main.async {
                self?.authorizationStatus = status
            }
        }
    }
    
    func fetchPhotos() {
        isLoading = true
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        var fetchedPhotos: [PhotoItem] = []
        fetchResult.enumerateObjects { asset, _, _ in
            let item = PhotoItem(id: asset.localIdentifier, asset: asset)
            fetchedPhotos.append(item)
        }
        
        self.photos = fetchedPhotos
        self.isLoading = false
    }
    
    func loadThumbnail(for asset: PHAsset, size: CGSize) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isSynchronous = false
            options.isNetworkAccessAllowed = true
            
            var didResume = false
            
            imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) { image, info in
                if !didResume {
                    didResume = true
                    continuation.resume(returning: image)
                }
            }
        }
    }
    
    func deleteAsset(asset: PHAsset) async throws {
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets([asset] as NSArray)
        }
    }
}
