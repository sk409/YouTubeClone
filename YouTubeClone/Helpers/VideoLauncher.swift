import UIKit

struct VideoLauncher {
    
    func showVideoPlayer() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let initialViewSize = CGSize(width: 10, height: 10)
        let view = UIView()
        window.addSubview(view)
        view.backgroundColor = .white
        view.frame = CGRect(x: window.bounds.width - initialViewSize.width, y: window.bounds.height - initialViewSize.height, width: initialViewSize.width, height: initialViewSize.height)
        let videoPlayerView = VideoPlayerView()
        view.addSubview(videoPlayerView)
        videoPlayerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoPlayerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            videoPlayerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            videoPlayerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            videoPlayerView.heightAnchor.constraint(equalTo: videoPlayerView.widthAnchor, multiplier: 9 / 16),
            ])
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            view.frame = window.frame
        })
    }
    
}
