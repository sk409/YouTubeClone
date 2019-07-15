

struct Setting {
    
    enum Target {
        case settings
        case privacy
        case sendFeedback
        case help
        case switchAccount
        case none
    }
    
    let name: String
    let iconName: String
    let target: Target
    
}
