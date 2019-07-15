import UIKit

class SettingTableViewCell: UITableViewCell {
    
    var setting: Setting? {
        didSet {
            if let iconName = setting?.iconName {
                iconImageView.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
            }
            nameLabel.text = setting?.name
        }
    }
    
    let iconImageView = UIImageView()
    let nameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setAppearance(backgroundColor: UIColor, iconTintColor: UIColor, nameTextColor: UIColor) {
        contentView.backgroundColor = backgroundColor
        iconImageView.tintColor = iconTintColor
        nameLabel.textColor = nameTextColor
    }
    
    private func setupViews() {
        addSubview(iconImageView)
        addSubview(nameLabel)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            iconImageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            iconImageView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.666),
            ])
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ])
    }
}
