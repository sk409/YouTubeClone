import UIKit

class AuthViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let containerStackView = UIStackView()
    let textFieldsStackView = UIStackView()
    let userNameTextField = UITextField()
    let passwordTextField = UITextField()
    let buttonsStackView = UIStackView()
    let loginButton = UIButton()
    let signupButton = UIButton()
    let activityIndicatorView = UIActivityIndicatorView()
    
    var parameters: [URLQueryItem]? {
        guard let userName = userNameTextField.text, let password = passwordTextField.text else {
            return nil
        }
        return [
            URLQueryItem(name: Database.Key.userName, value: userName),
            URLQueryItem(name: Database.Key.password, value: password)
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizers()
        addObservers()
        setupViews()
    }
    
    private func addGestureRecognizers() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:))))
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(observeKeyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(observeKeyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        view.addSubview(activityIndicatorView)
        scrollView.addSubview(containerStackView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
        containerStackView.addArrangedSubview(textFieldsStackView)
        containerStackView.addArrangedSubview(buttonsStackView)
        containerStackView.distribution = .fillEqually
        containerStackView.axis = .vertical
        containerStackView.spacing = 20
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            containerStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            containerStackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            containerStackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.4)
            ])
        textFieldsStackView.addArrangedSubview(userNameTextField)
        textFieldsStackView.addArrangedSubview(passwordTextField)
        textFieldsStackView.spacing = containerStackView.spacing / 2
        textFieldsStackView.distribution = .fillEqually
        textFieldsStackView.axis = .vertical
        userNameTextField.delegate = self
        userNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        userNameTextField.layer.borderWidth = 1
        userNameTextField.placeholder = "ユーザ名"
        passwordTextField.delegate = self
        passwordTextField.layer.borderColor = userNameTextField.layer.borderColor
        passwordTextField.layer.borderWidth = userNameTextField.layer.borderWidth
        passwordTextField.placeholder = "パスワード"
        passwordTextField.isSecureTextEntry = true
        buttonsStackView.addArrangedSubview(loginButton)
        buttonsStackView.addArrangedSubview(signupButton)
        buttonsStackView.spacing = textFieldsStackView.spacing
        buttonsStackView.distribution = textFieldsStackView.distribution
        buttonsStackView.axis = textFieldsStackView.axis
        loginButton.backgroundColor = .appColorLight
        loginButton.titleLabel?.font = .boldSystemFont(ofSize: 24)
        loginButton.setTitle("ログイン", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.addTarget(self, action: #selector(handleLoginButton(_:)), for: .touchUpInside)
        signupButton.backgroundColor = .appColorLight
        signupButton.titleLabel?.font = .boldSystemFont(ofSize: 24)
        signupButton.setTitle("登録", for: .normal)
        signupButton.setTitleColor(.white, for: .normal)
        signupButton.addTarget(self, action: #selector(handleSignupButton(_:)), for: .touchUpInside)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 44),
            activityIndicatorView.heightAnchor.constraint(equalTo: activityIndicatorView.widthAnchor),
            ])
    }
    
    private func login() {
        guard let parameters = parameters else {
            return
        }
        Database.async(fileName: Database.Script.PHP.fetchUser, method: .get, parameters: parameters) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            guard let user = try? JSONDecoder().decode(User.self, from: data) else {
                return
            }
            _ = Auth.login(id: user.id, name: user.name)
            DispatchQueue.main.async {
                let homeViewController = HomeViewController()
                homeViewController.user = user
                self.present(homeViewController, animated: true)
            }
        }
    }
    
    private func presentAlert(message: String, dismissalHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            alertController.dismiss(animated: true)
            dismissalHandler?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    @objc
    private func handleTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc
    private func observeKeyboardWillShowNotification(_ notification: Notification) {
        guard let keyboardInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        let keyboardSize = keyboardInfo.cgRectValue.size
        let buffer: CGFloat = 16
        let bottomInset = buttonsStackView.frame.maxY - (view.bounds.height - keyboardSize.height) + view.safeAreaInsets.top + buffer
        if 0 < bottomInset {
            UIView.animate(withDuration: duration) {
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
                self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
            }
        }
    }
    
    @objc
    private func observeKeyboardWillHideNotification(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset = .zero
            self.scrollView.scrollIndicatorInsets = .zero
        }
    }
    
    @objc
    private func handleLoginButton(_ sender: UIButton) {
        guard let parameters = parameters else {
            return
        }
        activityIndicatorView.startAnimating()
        Database.async(fileName: Database.Script.PHP.login, method: .get, parameters: parameters) { data, response, error in
            defer {
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                }
            }
            guard let data = data, let string = String(data: data, encoding: .utf8), string == Database.Response.succeeded, error == nil else {
                DispatchQueue.main.async {
                    self.presentAlert(message: "ログインに失敗しました")
                }
                return
            }
            DispatchQueue.main.async {
                self.presentAlert(message: "ログインに成功しました") {
                    self.login()
                }
            }
        }
    }
    
    @objc
    private func handleSignupButton(_ sender: UIButton) {
        guard let parameters = parameters else {
            return
        }
        activityIndicatorView.startAnimating()
        Database.async(fileName: Database.Script.PHP.registerUser, method: .post, parameters: parameters) { data, response, error in
            defer {
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                }
            }
            guard let data = data, let string = String(data: data, encoding: .utf8), string == Database.Response.succeeded, error == nil else {
                DispatchQueue.main.async {
                    self.presentAlert(message: "登録に失敗しました")
                }
                return
            }
            DispatchQueue.main.async {
                self.presentAlert(message: "登録に成功しました") {
                    self.login()
                }
            }
        }
    }
    
}

extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}
