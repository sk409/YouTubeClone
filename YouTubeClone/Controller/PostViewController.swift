import AVFoundation
import MobileCoreServices
import UIKit

class PostViewController: UIViewController {
    
    let thumbnailImageView = UIImageView()
    let movieSelectionButton = UIButton(type: .system)
    let thumbnailSelectionButton = UIButton(type: .system)
    let topSeparatorView = UIView()
    let titleTextField = UITextField()
    let summaryColumnTextView = UITextView()
    let bottomSeparatorView = UIView()
    let postButton = UIButton(type: .system)
    
    private var movieData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        let headView = UIView()
        headView.backgroundColor = .white
        let bodyView = UIView()
        bodyView.backgroundColor = .white
        let footView = UIView()
        footView.backgroundColor = .white
        view.addSubview(headView)
        view.addSubview(topSeparatorView)
        view.addSubview(bodyView)
        view.addSubview(bottomSeparatorView)
        view.addSubview(footView)
        headView.addSubview(thumbnailImageView)
        headView.addSubview(movieSelectionButton)
        headView.addSubview(thumbnailSelectionButton)
        bodyView.addSubview(titleTextField)
        bodyView.addSubview(summaryColumnTextView)
        footView.addSubview(postButton)
        headView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3),
            ])
        topSeparatorView.backgroundColor = .black
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topSeparatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topSeparatorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topSeparatorView.topAnchor.constraint(equalTo: headView.bottomAnchor),
            topSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            ])
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bodyView.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor),
            bodyView.bottomAnchor.constraint(equalTo: bottomSeparatorView.topAnchor),
            ])
        bottomSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomSeparatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomSeparatorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomSeparatorView.bottomAnchor.constraint(equalTo: footView.topAnchor),
            bottomSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            ])
        footView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            footView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            footView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footView.heightAnchor.constraint(equalToConstant: 64),
            ])
        thumbnailImageView.contentMode = .scaleAspectFit
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            thumbnailImageView.centerYAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.centerYAnchor),
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor),
            thumbnailImageView.heightAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.8)
            ])
        let marginBetweenSelectionButtons: CGFloat = 8
        movieSelectionButton.backgroundColor = .appColorLight
        movieSelectionButton.setTitle("動画を選択", for: .normal)
        movieSelectionButton.setTitleColor(.white, for: .normal)
        movieSelectionButton.addTarget(self, action: #selector(handleMovieSelectionButton(_:)), for: .touchUpInside)
        movieSelectionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieSelectionButton.trailingAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            movieSelectionButton.bottomAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.centerYAnchor, constant: -marginBetweenSelectionButtons),
            movieSelectionButton.widthAnchor.constraint(equalTo: thumbnailSelectionButton.widthAnchor),
            movieSelectionButton.heightAnchor.constraint(equalToConstant: 44),
            ])
        thumbnailSelectionButton.backgroundColor = .appColorLight
        thumbnailSelectionButton.isEnabled = false
        thumbnailSelectionButton.setTitle("サムネイルを選択", for: .normal)
        thumbnailSelectionButton.setTitle("サムネイルを選択", for: .disabled)
        thumbnailSelectionButton.setTitleColor(.white, for: .normal)
        thumbnailSelectionButton.setTitleColor(.darkGray, for: .disabled)
        thumbnailSelectionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbnailSelectionButton.trailingAnchor.constraint(equalTo: movieSelectionButton.trailingAnchor),
            thumbnailSelectionButton.topAnchor.constraint(equalTo: headView.centerYAnchor, constant: marginBetweenSelectionButtons),
            thumbnailSelectionButton.heightAnchor.constraint(equalTo: movieSelectionButton.heightAnchor)
            ])
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        titleTextField.layer.borderWidth = 1
        titleTextField.backgroundColor = .white
        titleTextField.font = .systemFont(ofSize: 20)
        titleTextField.placeholder = "タイトル"
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleTextField.centerXAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.centerXAnchor),
            titleTextField.topAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleTextField.widthAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            titleTextField.heightAnchor.constraint(equalToConstant: 44),
            ])
        summaryColumnTextView.delegate = self
        summaryColumnTextView.layer.borderColor = UIColor.lightGray.cgColor
        summaryColumnTextView.layer.borderWidth = 1
        summaryColumnTextView.text = "概要"
        summaryColumnTextView.textColor = .lightGray
        summaryColumnTextView.font = .systemFont(ofSize: 18)
        summaryColumnTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            summaryColumnTextView.centerXAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.centerXAnchor),
            summaryColumnTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            summaryColumnTextView.bottomAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            summaryColumnTextView.widthAnchor.constraint(equalTo: titleTextField.widthAnchor),
            ])
        postButton.backgroundColor = .appColorLight
        postButton.setTitle("投稿", for: .normal)
        postButton.setTitleColor(.white, for: .normal)
        postButton.addTarget(self, action: #selector(handlePostButton(_:)), for: .touchUpInside)
        postButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postButton.centerXAnchor.constraint(equalTo: footView.centerXAnchor),
            postButton.centerYAnchor.constraint(equalTo: footView.centerYAnchor),
            postButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 88),
            postButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            ])
    }
    
    @objc
    private func handleMovieSelectionButton(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [kUTTypeMovie as String]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc
    private func handlePostButton(_ sender: UIButton) {
        guard let user = Auth.user,
            let title = titleTextField.text,
            let overview = summaryColumnTextView.text,
            let movieDataString = movieData?.base64EncodedString() else {
                return
        }
        let insertMovieParameters = [URLQueryItem(name: "user_id", value: String(user.id)), URLQueryItem(name: "title", value: title), URLQueryItem(name: "overview", value: overview)]
        guard let movieIdData = Database.sync(fileName: Database.Script.PHP.insertMovie, method: .post, parameters: insertMovieParameters).data else {
            return
        }
        guard let movieId = String(data: movieIdData, encoding: .utf8) else {
            return
        }
        var urlAllowedCharacterSet = CharacterSet.urlQueryAllowed
        urlAllowedCharacterSet.remove("?")
        urlAllowedCharacterSet.remove("&")
        urlAllowedCharacterSet.remove("+")
        var index = 0
        let length = 50000
        while index < movieDataString.count {
            let upperBound = min(movieDataString.count, index + length)
            let blob = movieDataString[movieDataString.index(movieDataString.startIndex, offsetBy: index)..<movieDataString.index(movieDataString.startIndex, offsetBy: upperBound)].addingPercentEncoding(withAllowedCharacters: urlAllowedCharacterSet)!
            let parameters = [
                URLQueryItem(name: "user_id", value: String(user.id)),
                URLQueryItem(name: "movie_id", value: movieId),
                URLQueryItem(name: "blob", value: blob)
            ]
            let result = Database.sync(fileName: Database.Script.PHP.concatMovieBlob, method: .post, parameters: parameters)
            guard let data = result.data, let string = String(data: data, encoding: .utf8), string == Database.Response.succeeded else {
                return
            }
            index += length
        }
        alert(message: "投稿しました")
    }
    
}

extension PostViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if summaryColumnTextView.text == "概要" {
            summaryColumnTextView.text = ""
            summaryColumnTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if summaryColumnTextView.text == "" {
            summaryColumnTextView.text = "概要"
            summaryColumnTextView.textColor = .lightGray
        }
    }
    
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let mediaURL = info[.mediaURL] as? URL else {
            return
        }
        let asset = AVURLAsset(url: mediaURL, options: nil)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        if let thumbnailCGImage = try? imageGenerator.copyCGImage(at: CMTime(value: 0, timescale: 1), actualTime: nil) {
            thumbnailImageView.image = UIImage(cgImage: thumbnailCGImage)
        }
        movieData = try? Data(contentsOf: mediaURL)
//        guard let videoURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("sample_movie.mov") else {
//            return
//        }
//        try! (try! Data(contentsOf: mediaURL).base64EncodedString()).write(to: videoURL, atomically: true, encoding: .utf8)
        picker.dismiss(animated: true)
    }
    
}
