import FinderSync
import Observation
import ServiceManagement

@Observable class PermissionSettingsViewModel {
    var isEnableFinderExtension: Bool
    var allowedDirectory: String?
    var launchAtLogin = SMAppService.loginItem(identifier: "ShowyaTanaka.FinderFileUtility-2.FFU2-Daemon").status
    let nsAlertService: NSAlertServiceProtocol.Type
    var isAllowedDirectory: Bool {
        return self.allowedDirectory != nil
    }
    let service = SMAppService.loginItem(identifier: "ShowyaTanaka.FinderFileUtility-2.FFU2-Daemon")

    init(userDefaultsModel: UserDefaultsModelProtocol, nsAlertService: NSAlertServiceProtocol.Type) {
        self.isEnableFinderExtension = FIFinderSyncController.isExtensionEnabled
        self.nsAlertService = nsAlertService
        print("isEnableFinderExtension: \(self.isEnableFinderExtension)")
        self.allowedDirectory = userDefaultsModel.getStringValue(forKey: UserDefaultsKey.bookMarkPathKey)
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
        } catch let error as NSError {
            let detail = "(code: \(error.code)) \(error.localizedDescription)"
            self.nsAlertService.showAlert(title: "Error", message: "ログイン時起動の登録に失敗しました\n\(detail)")
        } catch {
            self.nsAlertService.showAlert(title: "Error", message: "ログイン時起動の登録に失敗しました\n\(error.localizedDescription)")
        }
        self.launchAtLogin = self.service.status
    }
    func unregisterLogin() {
        do {
            try self.service.unregister()
        } catch {
            self.nsAlertService.showAlert(title: "Error", message: "ログイン時起動の解除に失敗しました")
        }
        self.launchAtLogin = self.service.status
    }
}

