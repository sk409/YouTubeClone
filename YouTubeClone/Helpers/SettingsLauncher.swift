import UIKit

class SettingsLauncher: NSObject {
    
    private static let cellId = "cellId"
    
    weak var homeCollectionViewController: HomeViewController?
    
    var defaultCellBackgroundColor = UIColor.white
    var defaultNameTextColor = UIColor.black
    var defaultIconImageTintColor = UIColor.lightGray
    var selectedCellBackgroundColor = UIColor.darkGray
    var selectedNameTextColor = UIColor.white
    var selectedIconImageTintColor = UIColor.white
    var cellHeight: CGFloat = 50
    
    let blackView = UIView()
    let tableView = UITableView()
    
    private let settings = [
        Setting(name: "Setting", iconName: "settings", target: .settings),
        Setting(name: "Terms & privacy policy", iconName: "privacy", target: .privacy),
        Setting(name: "Send Feedback", iconName: "feedback", target: .sendFeedback),
        Setting(name: "Help", iconName: "help", target: .help),
        Setting(name: "Switch Account", iconName: "switch_account", target: .switchAccount),
        Setting(name: "Cancel", iconName: "cancel", target: .none),
    ]
    
    override init() {
        super.init()
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDissmissingTapGestureRecognizer(_:))))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingsLauncher.cellId)
    }
    
    func showSettings() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        window.addSubview(blackView)
        window.addSubview(tableView)
        blackView.alpha = 0
        blackView.frame = CGRect(origin: .zero, size: window.bounds.size)
        let tableViewHeight = cellHeight * CGFloat(settings.count) + window.safeAreaInsets.bottom
        tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.safeAreaLayoutGuide.layoutFrame.width, height: tableViewHeight)
        tableView.reloadData()
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.blackView.alpha = 1
            self.tableView.frame.origin.y = (window.frame.height - tableViewHeight)
        })
    }
    
    func hideSettings(completion: ((Bool) -> Void)?) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y = window.frame.height
        }, completion: completion)
    }
    
    
    @objc
    private func handleDissmissingTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        hideSettings(completion: nil)
    }
    
}

extension SettingsLauncher: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsLauncher.cellId) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        cell.setting = settings[indexPath.row]
        cell.iconImageView.contentMode = .scaleAspectFill
        cell.setAppearance(backgroundColor: defaultCellBackgroundColor, iconTintColor: defaultIconImageTintColor, nameTextColor: defaultNameTextColor)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SettingTableViewCell else {
            return
        }
        cell.setAppearance(backgroundColor: selectedCellBackgroundColor, iconTintColor: selectedIconImageTintColor, nameTextColor: selectedNameTextColor)
        hideSettings() { succeeded in
            guard succeeded else {
                return
            }
            let setting = self.settings[indexPath.row]
            if setting.target != .none {
                self.homeCollectionViewController?.pushViewController(for: setting)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SettingTableViewCell else {
            return
        }
        cell.setAppearance(backgroundColor: defaultCellBackgroundColor, iconTintColor: defaultIconImageTintColor, nameTextColor: defaultNameTextColor)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
}
