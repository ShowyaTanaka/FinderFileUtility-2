@testable import FFU2_Daemon
import Testing

struct FileSecureBookMarkTestMockNSAlertService: NSAlertServiceProtocol {

    // 記録用
    static private(set) var shownAlerts: [(title: String, message: String)] = []
    static var userSelectResult: Bool = true
    static var showAlertCalledCount: Int = 0
    static var showAlertWithUserSelectCalledCount: Int = 0

    static func showAlert(title: String, message: String) {
        showAlertCalledCount += 1
        shownAlerts.append((title, message))
    }

    static func showAlertWithUserSelect(title: String, message: String) -> Bool {
        shownAlerts.append((title, message))
        showAlertWithUserSelectCalledCount += 1
        return userSelectResult
    }

    /// テスト補助
    static func reset() {
        showAlertCalledCount = 0
        showAlertWithUserSelectCalledCount = 0
        shownAlerts.removeAll()
        userSelectResult = true
    }
}
