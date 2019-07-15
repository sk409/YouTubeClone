import UIKit

class Channel {
    
    let name: String
    let profileImage: UIImage
    let videos: [Video]
    
    init(name: String, profileImage: UIImage, videos: [Video]) {
        self.name = name
        self.profileImage = profileImage
        self.videos = videos
        self.videos.forEach { $0.channel = self }
    }
    
}
