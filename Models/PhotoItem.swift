import Foundation
import Photos
import UIKit

struct PhotoItem: Identifiable {
    let id: String
    let asset: PHAsset
    var thumbnail: UIImage?
}
