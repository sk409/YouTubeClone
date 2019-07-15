import AVFoundation
import UIKit

class HomeViewController: UIViewController {
    
    private static let testCellId = "testCellId"
    private static let feedCollectionViewCellId = "feedCollectionViewCellId"
    private static let accountCollectionViewCellId = "accountCollectionViewCellId"
    
    var user: User?
    
    let menuBarView = MenuBarView()
    let r = UIViewController()
    let g = UIViewController()
    let b = UIViewController()
    let accountViewController = AccountViewController()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        return collectionViewLayout
    }())
    
    private var videos: [Video]?
    private let settingsLauncher = SettingsLauncher()
    private let channels = Database.fetchChannles()
    private var viewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        r.view.backgroundColor = .red
        g.view.backgroundColor = .green
        b.view.backgroundColor = .blue
        viewControllers = [r,g,b,accountViewController]
        setupNavigation()
        setupViews()
        setupHelpers()
        fetchVideos()
        //VideoLauncher().showVideoPlayer()
    }
    
    func pushViewController(for setting: Setting) {
        let viewController = SettingContainerViewController()
        viewController.view.backgroundColor = .white
        viewController.navigationItem.title = setting.name
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setupNavigation() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: navigationItem.accessibilityFrame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMoreBarButton(_:))),
            UIBarButtonItem(image: UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSearchBarButton(_:))),
        ]
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(menuBarView)
        view.addSubview(collectionView)
        menuBarView.homeCollectionViewController = self
        menuBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            menuBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            menuBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuBarView.heightAnchor.constraint(equalToConstant: 44),
            ])
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: HomeViewController.feedCollectionViewCellId)
        collectionView.register(AccountCollectionViewCell.self, forCellWithReuseIdentifier: HomeViewController.accountCollectionViewCellId)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: HomeViewController.testCellId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: menuBarView.bottomAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
    }
    
    private func setupHelpers() {
        settingsLauncher.homeCollectionViewController = self
    }
    
    private func fetchVideos() {
        videos = channels.reduce([Video](), { $0 + $1.videos })
    }
    
    @objc
    private func handleSearchBarButton(_ sender: UIBarButtonItem) {
    }
    
    @objc
    private func handleMoreBarButton(_ sender: UIBarButtonItem) {
        settingsLauncher.showSettings()
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int((scrollView.contentOffset.x + scrollView.bounds.width * 0.5) / scrollView.bounds.width)
        (navigationItem.titleView as? UILabel)?.text = menuBarView.items[index].name
        let x = scrollView.contentOffset.x / CGFloat(menuBarView.items.count)
        menuBarView.scrollHorizontalBar(to: x)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.testCellId, for: indexPath)
        for subview in cell.subviews {
            for viewController in viewControllers {
                if viewController.view == subview {
                    viewController.willMove(toParent: self)
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParent()
                }
            }
        }
        let v = indexPath.item == 0 ? r : indexPath.item == 1 ? g : indexPath.item == 2 ? b : accountViewController
        if v.view.superview != nil {
            v.willMove(toParent: self)
            v.view.removeFromSuperview()
            v.removeFromParent()
        }
        addChild(v)
        v.view.frame = cell.bounds
        cell.addSubview(v.view)
        v.didMove(toParent: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
