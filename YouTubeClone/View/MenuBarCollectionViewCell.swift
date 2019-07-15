import UIKit

class MenuBarCollectionViewCell: UICollectionViewCell {
    
    static let activeImageTintColor = UIColor.white
    static let inactiveImageTintColor = UIColor(red: 91/255, green: 14/255, blue: 13/255, alpha: 1)
    
    override var isHighlighted: Bool {
        didSet {
            activateImageView(isAcitve: isHighlighted)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            activateImageView(isAcitve: isSelected)
        }
    }
    
    var image: UIImage? {
        didSet {
            imageView.image = image?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(imageView)
        imageView.tintColor = MenuBarCollectionViewCell.inactiveImageTintColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.3333),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            ])
    }
    
    private func activateImageView(isAcitve: Bool) {
        imageView.tintColor = isAcitve ? MenuBarCollectionViewCell.activeImageTintColor : MenuBarCollectionViewCell.inactiveImageTintColor
    }
    
}
