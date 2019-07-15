import UIKit

class MenuBarView: UIView {
    
    private static let cellId = "cellId"
    
    weak var homeCollectionViewController: HomeViewController?
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let horizontalBar = UIView()
    
    let items = [
        MenuBarItem(name: "Home", imageName: "home"),
        MenuBarItem(name: "Trending", imageName: "trending"),
        MenuBarItem(name: "Subscription", imageName: "subscriptions"),
        MenuBarItem(name: "Account", imageName: "switch_account")
    ]
    
    private var horizontalBarLeadingAnchorConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func scrollHorizontalBar(to x: CGFloat) {
        guard safeAreaLayoutGuide.layoutFrame.width != 0.0 else {
            return
        }
        let index = Int((x + (safeAreaLayoutGuide.layoutFrame.width / (CGFloat(items.count) * 2))) / safeAreaLayoutGuide.layoutFrame.width * CGFloat(items.count))
        collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .left)
        horizontalBarLeadingAnchorConstraint?.constant = x
        layoutIfNeeded()
    }
    
    private func setupViews() {
        addSubview(collectionView)
        addSubview(horizontalBar)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .appColorLight
        collectionView.register(MenuBarCollectionViewCell.self, forCellWithReuseIdentifier: MenuBarView.cellId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ])
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
        horizontalBar.backgroundColor = UIColor(white: 0.95, alpha: 1)
        horizontalBarLeadingAnchorConstraint = horizontalBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        horizontalBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalBarLeadingAnchorConstraint!,
            horizontalBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            horizontalBar.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1 / CGFloat(items.count)),
            horizontalBar.heightAnchor.constraint(equalToConstant: 4),
            ])
    }
    
}

extension MenuBarView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuBarView.cellId, for: indexPath) as? MenuBarCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.image = UIImage(named: items[indexPath.item].imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let x = safeAreaLayoutGuide.layoutFrame.width / CGFloat(iconImages.count) * CGFloat(indexPath.item)
//        scrollHorizontalBar(to: x)
        homeCollectionViewController?.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: safeAreaLayoutGuide.layoutFrame.width / CGFloat(items.count), height: safeAreaLayoutGuide.layoutFrame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
