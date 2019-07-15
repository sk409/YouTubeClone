import UIKit

class AccountCollectionViewCell: UICollectionViewCell {
    
    let nameLabel = UILabel()
    let postButton = UIButton()
    let separator = UIView()
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let headerView = UIView()
        addSubview(headerView)
        headerView.addSubview(nameLabel)
        headerView.addSubview(postButton)
        addSubview(separator)
        addSubview(tableView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.2),
            ])
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.text = "名前"
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.centerYAnchor),
            ])
        postButton.backgroundColor = .appColorLight
        postButton.titleLabel?.font = .systemFont(ofSize: 16)
        postButton.setTitle("動画投稿", for: .normal)
        postButton.setTitleColor(.white, for: .normal)
        postButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postButton.trailingAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            postButton.centerYAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.centerYAnchor),
            postButton.widthAnchor.constraint(equalToConstant: 80),
            postButton.heightAnchor.constraint(equalToConstant: 40),
            ])
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .lightGray
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            separator.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            ])
    }
    
}
