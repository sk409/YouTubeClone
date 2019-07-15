import UIKit

class Video: NSObject {
    
    weak var channel: Channel?
    let title: String
    let thumbnailImage: UIImage?
    let numberOfViews: Int
    
    init(title: String, thumbnailImage: UIImage, numberOfViews: Int) {
        self.title = title
        self.thumbnailImage = thumbnailImage
        self.numberOfViews = numberOfViews
        super.init()
    }
    
}
