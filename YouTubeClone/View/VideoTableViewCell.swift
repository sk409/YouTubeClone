import UIKit

class VideoTableViewCell: UITableViewCell {
    
    var video: Video? {
        didSet {
            guard let video = video else {
                return
            }
            thumbnailImageView.image = video.thumbnailImage
            userProfileImageView.image = video.channel?.profileImage
            titleLabel.text = video.title
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            if let formattedNumberOfViews = numberFormatter.string(from: NSNumber(value: video.numberOfViews)),
               let channelName = video.channel?.name
            {
                subtitleTextView.text = channelName + " - " + formattedNumberOfViews
            }
        }
    }
    
    let thumbnailImageView = UIImageView()
    let userProfileImageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleTextView = UITextView()
    let separatorView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        addSubview(separatorView)
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            thumbnailImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            thumbnailImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            thumbnailImageView.bottomAnchor.constraint(equalTo: userProfileImageView.topAnchor, constant: -8),
            ])
        let userProfileImageViewSize: CGFloat = 44
        userProfileImageView.contentMode = .scaleAspectFill
        userProfileImageView.layer.cornerRadius = userProfileImageViewSize / 2
        userProfileImageView.layer.masksToBounds = true
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userProfileImageView.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor),
            userProfileImageView.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -16),
            userProfileImageView.widthAnchor.constraint(equalToConstant: userProfileImageViewSize),
            userProfileImageView.heightAnchor.constraint(equalTo: userProfileImageView.widthAnchor),
            ])
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: userProfileImageView.topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            ])
        subtitleTextView.textColor = .lightGray
        subtitleTextView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        subtitleTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleTextView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleTextView.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            ])
        separatorView.backgroundColor = UIColor(white: 0.8, alpha: 1)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            ])
    }
    
}
