import Foundation

struct Auth {
    
    struct Key {
        static let id = "AUTH_USER_ID_KEY_NAME"
        static let name = "AUTH_USER_NAME_KEY_NAME"
    }
    
    static var user: User? {
        guard let id = UserDefaults.standard.value(forKey: Auth.Key.id) as? Int,
              let name = UserDefaults.standard.value(forKey: Auth.Key.name) as? String
        else {
            return nil
        }
        return User(id: id, name: name)
    }
    
    static func login(id: Int, name: String) -> User {
        UserDefaults.standard.setValue(id, forKey: Auth.Key.id)
        UserDefaults.standard.setValue(name, forKey: Auth.Key.name)
        return User(id: id, name: name)
    }
    
}
