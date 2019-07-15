import AVFoundation
import UIKit

class VideoPlayerView: UIView {
    
    var isPlaying: Bool {
        guard let player = player else {
            return false
        }
        return player.rate != 0 && player.error == nil
    }
    
    let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    let controlsContainerView = UIView()
    let playingPausingButton = UIButton()
    let elapsedTimeLabel = UILabel()
    let durationLabel = UILabel()
    let elapsedTimeSlider = ElapsedTimeSlider()
    
    private var movieData: Data?
    private var player: AVPlayer?
    private var timer: Timer?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        addObservers()
        setupGestureRecognizers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        addObservers()
        setupGestureRecognizers()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupGradientLayer()
        setupVideo()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(observePlayerItemNewAccessLogEntry(_:)), name: .AVPlayerItemNewAccessLogEntry, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(observePlayerItemDidPlayToEndTime(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    private func setupGestureRecognizers() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleScreenTapGestureRecognizer(_:))))
    }
    
    private func setupViews() {
        backgroundColor = .black
        addSubview(controlsContainerView)
        addSubview(activityIndicatorView)
        controlsContainerView.addSubview(playingPausingButton)
        controlsContainerView.addSubview(durationLabel)
        controlsContainerView.addSubview(elapsedTimeLabel)
        controlsContainerView.addSubview(elapsedTimeSlider)
        controlsContainerView.alpha = 0
        controlsContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        controlsContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controlsContainerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            controlsContainerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            controlsContainerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            controlsContainerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ])
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 44),
            activityIndicatorView.heightAnchor.constraint(equalTo: activityIndicatorView.widthAnchor),
            ])
        playingPausingButton.setImage(UIImage(named: "pause"), for: .normal)
        playingPausingButton.addTarget(self, action: #selector(handlePlayingPausingButton(_:)), for: .touchUpInside)
        playingPausingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playingPausingButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            playingPausingButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            playingPausingButton.widthAnchor.constraint(equalToConstant: 44),
            playingPausingButton.heightAnchor.constraint(equalTo: playingPausingButton.widthAnchor),
            ])
        elapsedTimeLabel.font = .boldSystemFont(ofSize: 13)
        elapsedTimeLabel.textColor = .white
        elapsedTimeLabel.textAlignment = .center
        elapsedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            elapsedTimeLabel.leadingAnchor.constraint(equalTo: controlsContainerView.safeAreaLayoutGuide.leadingAnchor),
            elapsedTimeLabel.trailingAnchor.constraint(equalTo: elapsedTimeSlider.leadingAnchor),
            elapsedTimeLabel.centerYAnchor.constraint(equalTo: elapsedTimeSlider.centerYAnchor),
            ])
        durationLabel.font = .boldSystemFont(ofSize: 13)
        durationLabel.textColor = .white
        durationLabel.textAlignment = .center
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            durationLabel.leadingAnchor.constraint(equalTo: elapsedTimeSlider.trailingAnchor),
            durationLabel.trailingAnchor.constraint(equalTo: controlsContainerView.safeAreaLayoutGuide.trailingAnchor),
            durationLabel.centerYAnchor.constraint(equalTo: elapsedTimeSlider.centerYAnchor),
            ])
        elapsedTimeSlider.minimumTrackTintColor = .red
        elapsedTimeSlider.maximumTrackTintColor = .white
        elapsedTimeSlider.setThumbImage(UIImage(named: "slider_thumb"), for: .normal)
        elapsedTimeSlider.addTarget(self, action: #selector(handleElapsedTimeSliderValueChangedEvent(_:)), for: .valueChanged)
        elapsedTimeSlider.addTarget(self, action: #selector(handleElapsedTimeSliderTouchDownEvent(_:)), for: .touchDown)
        elapsedTimeSlider.addTarget(self, action: #selector(handleElapsedTimeSliderTouchUpEvent(_:)), for: .touchUpInside)
        elapsedTimeSlider.addTarget(self, action: #selector(handleElapsedTimeSliderTouchUpEvent(_:)), for: .touchUpOutside)
        elapsedTimeSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            elapsedTimeSlider.centerXAnchor.constraint(equalTo: controlsContainerView.safeAreaLayoutGuide.centerXAnchor),
            elapsedTimeSlider.bottomAnchor.constraint(equalTo: controlsContainerView.safeAreaLayoutGuide.bottomAnchor, constant: -2),
            elapsedTimeSlider.widthAnchor.constraint(equalTo: controlsContainerView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            elapsedTimeSlider.heightAnchor.constraint(equalTo: durationLabel.heightAnchor),
            ])
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.2]
        controlsContainerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupVideo() {
        
        /****************************/
        // TEST
        let movieId = "1"
        /****************************/
        
        guard let user = Auth.user else {
            return
        }
        let getMovieDataSizeParameters = [URLQueryItem(name: "movie_id", value: movieId), URLQueryItem(name: "user_id", value: String(user.id))]
        guard let movieDataSizeData = Database.sync(fileName: Database.Script.PHP.getMovieDataSize, method: .get, parameters: getMovieDataSizeParameters).data else {
            return
        }
        guard let movieDataSize = Int(String(data: movieDataSizeData, encoding: .utf8) ?? "") else {
            return
        }
        var index = 0
        let length = 50000
        var fetchedString = ""
        while index < movieDataSize {
//            if index.isMultiple(of: 100000) {
//                print(String(index) + " / " + String(movieDataSize))
//            }
            let parameters = [
                URLQueryItem(name: "user_id", value: String(user.id)),
                URLQueryItem(name: "movie_id", value: movieId),
                URLQueryItem(name: "offset", value: String(index)),
                URLQueryItem(name: "length", value: String(length))
            ]
            guard let data = Database.sync(fileName: Database.Script.PHP.fetchMovieDataBlob, method: .get, parameters: parameters).data else {
                return
            }
            guard let string = String(data: data, encoding: .utf8) else {
                return
            }
            fetchedString += string
            index += length
        }
        movieData = Data(base64Encoded: fetchedString)
        let asset = AVURLAsset(url: NSURL(string: "")! as URL)
        let resourceLoader = asset.resourceLoader
        resourceLoader.setDelegate(self, queue: DispatchQueue.main)
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        player?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 10), queue: DispatchQueue.main) { elapsedTime in
            let elapsedSeconds = Int(CMTimeGetSeconds(elapsedTime))
            let elapsedSecondsString = String(format: "%02d", elapsedSeconds % 60)
            let elapsedMinutesString = String(format: "%02d", elapsedSeconds / 60)
            self.elapsedTimeLabel.text = elapsedMinutesString + ":" + elapsedSecondsString
            self.elapsedTimeSlider.value = Float(elapsedSeconds)
            self.elapsedTimeSlider.value = Float(CMTimeGetSeconds(elapsedTime))
        }
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(origin: .zero, size: bounds.size)
        layer.insertSublayer(playerLayer, at: 0)
        activityIndicatorView.startAnimating()
    }
    
    private func showControls(withDuration duration: TimeInterval = 0.5, lifeTime: TimeInterval? = nil, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.controlsContainerView.alpha = 1
        }) { _ in
            if let lifeTime = lifeTime {
                self.hideControlsIfPlayerIsPlaying(withTimeInterval: lifeTime)
            }
            completion?()
        }
    }
    
    private func hideControlsIfPlayerIsPlaying(withTimeInterval timeInterval: TimeInterval = 1.5) {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { timer in
            if self.isPlaying {
                UIView.animate(withDuration: 0.5) {
                    self.controlsContainerView.alpha = 0
                }
            }
        }
    }
    
    @objc
    private func observePlayerItemNewAccessLogEntry(_ notification: Notification) {
        guard activityIndicatorView.isAnimating else {
            return
        }
        activityIndicatorView.stopAnimating()
        if let duration = player?.currentItem?.duration {
            let seconds = Int(CMTimeGetSeconds(duration))
            let secondsString = String(format: "%02d", seconds % 60)
            let minutesString = String(format: "%02d", seconds / 60)
            elapsedTimeLabel.text = "00:00"
            durationLabel.text = minutesString + ":" + secondsString
            elapsedTimeSlider.minimumValue = 0
            elapsedTimeSlider.maximumValue = Float(seconds)
        }
    }
    
    @objc
    private func observePlayerItemDidPlayToEndTime(_ notification: Notification) {
        playingPausingButton.setImage(UIImage(named: "play"), for: .normal)
        showControls()
    }
    
    @objc
    private func handlePlayingPausingButton(_ sender: UIButton) {
        if isPlaying {
            player?.pause()
            playingPausingButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            if let currentItem = player?.currentItem,
                CMTimeGetSeconds(currentItem.currentTime()) == CMTimeGetSeconds(currentItem.duration)
            {
                player?.seek(to: .zero)
            }
            player?.play()
            playingPausingButton.setImage(UIImage(named: "pause"), for: .normal)
            hideControlsIfPlayerIsPlaying()
        }
    }
    
    @objc
    private func handleElapsedTimeSliderValueChangedEvent(_ sender: UISlider) {
        player?.seek(to: CMTime(seconds: Double(elapsedTimeSlider.value), preferredTimescale: 1000), toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    @objc
    private func handleElapsedTimeSliderTouchDownEvent(_ sender: ElapsedTimeSlider) {
        sender.forcePlaying = isPlaying
        if isPlaying {
            player?.pause()
        }
    }
    
    @objc
    private func handleElapsedTimeSliderTouchUpEvent(_ sender: ElapsedTimeSlider) {
        if sender.forcePlaying {
            player?.play()
        }
    }
    
    @objc
    private func handleScreenTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        let animationDuration: TimeInterval = 0.5
        UIView.animate(withDuration: animationDuration, animations: {
            self.controlsContainerView.alpha = (self.controlsContainerView.alpha == 0) ? 1 : 0
        }) { _ in
            self.hideControlsIfPlayerIsPlaying()
        }
    }
    
}

extension VideoPlayerView: AVAssetResourceLoaderDelegate {
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        loadingRequest.contentInformationRequest?.contentType = "public.mpeg-4"
        loadingRequest.contentInformationRequest?.contentLength = Int64(movieData!.count)
        loadingRequest.contentInformationRequest?.isByteRangeAccessSupported = true
        let requestedData = movieData?.subdata(in: Int(loadingRequest.dataRequest!.requestedOffset)..<Int(loadingRequest.dataRequest!.requestedOffset + Int64(loadingRequest.dataRequest!.requestedLength)))
        loadingRequest.dataRequest?.respond(with: requestedData!)
        loadingRequest.finishLoading()
        return true
    }
    
}
