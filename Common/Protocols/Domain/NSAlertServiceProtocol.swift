protocol NSAlertServiceProtocol {
    static func showAlert(title: String, message: String)
    static func showAlertWithUserSelect(title: String, message: String) -> Bool
}
