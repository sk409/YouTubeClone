import MobileCoreServices
import UIKit

class AccountViewController: UIViewController {
    
    let nameLabel = UILabel()
    let postButton = UIButton()
    let separator = UIView()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        let headerView = UIView()
        view.addSubview(headerView)
        headerView.addSubview(nameLabel)
        headerView.addSubview(postButton)
        view.addSubview(separator)
        view.addSubview(tableView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2),
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
        postButton.addTarget(self, action: #selector(handlePostButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
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
            separator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            separator.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            ])
    }
    
    @objc
    private func handlePostButtonTouchUpInsideEvent(_ sender: UIButton) {
        present(PostViewController(), animated: true)
    }
    
}
