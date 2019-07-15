import Foundation
import Photos

struct VideoUtils {
    
    static func saveToPhotoLibaray(videoURL: URL) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
        }) { completed, error in
            if let error = error {
                print(error.localizedDescription)
            }
            //print(try? String(contentsOf: videoURL))
        }
    }
    
}
