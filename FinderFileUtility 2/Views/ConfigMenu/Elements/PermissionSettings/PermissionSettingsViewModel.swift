import FinderSync
import Observation
import ServiceManagement

@Observable class PermissionSettingsViewModel {
    var isEnableFinderExtension: Bool
    var allowedDirectory: String?
    var launchAtLogin = SMAppService.loginItem(identifier: "ShowyaTanaka.FinderFileUtility-2.FFU2-Daemon").status
    var isAllowedDirectory: Bool {
        return SecureBookMarkService.isBookMarkExists()
    }
    let service = SMAppService.loginItem(identifier: "ShowyaTanaka.FinderFileUtility-2.FFU2-Daemon")

    init() {
        self.isEnableFinderExtension = FIFinderSyncController.isExtensionEnabled
        print("isEnableFinderExtension: \(self.isEnableFinderExtension)")
        self.allowedDirectory = SecureBookMarkService.getSecureBookMarkStringFullPath()
    }

    func callSaveSecureBookMark() {
        DistributedNotificationCenter.default().postNotificationName(NSNotification.Name(NotificationKey.FFU2_DAEMON_SAVE_SECURITY_SCOPED_BOOKMARK_KEY), object: nil, userInfo: nil, deliverImmediately: true)
    }

    func isLaunchAtLoginEnabled() -> Bool {
        return self.service.status == .enabled
    }
    func registerLogin() {

        do {
            try self.service.register()
        } catch {
            NSAlertService.showAlert(title: "Error", message: "ログイン時起動の登録に失敗しました")
        }
        self.launchAtLogin = self.service.status
    }
    func unregisterLogin() {
        do {
            try self.service.unregister()
        } catch {
            NSAlertService.showAlert(title: "Error", message: "ログイン時起動の解除に失敗しました")
        }
        self.launchAtLogin = self.service.status
    }
}
