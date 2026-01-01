import Cocoa
import Foundation



class FileSecureBookMark: DistributedNotificationHandlerDelegate {
    var notificationKey = NotificationKey.FFU2_DAEMON_SAVE_SECURITY_SCOPED_BOOKMARK_KEY
    let nsAlertService: NSAlertServiceProtocol.Type
    let secureBookMarkService: SecureBookMarkServiceProtocol
    let nsOpenPanelService: NSOpenPanelServiceProtocol
    deinit {
        NSLog("FileSecureBookMark deinited")
    }
    init(nsAlertService: NSAlertServiceProtocol.Type=NSAlertService.self, secureBookMarkService: SecureBookMarkServiceProtocol, nsOpenPanelService: NSOpenPanelServiceProtocol){
        self.nsAlertService = nsAlertService
        self.secureBookMarkService = secureBookMarkService
        self.nsOpenPanelService = nsOpenPanelService
    }

    @MainActor // NSWindowがいるので主スレッド指定
    func saveSecureBookMark() async {
        /*
         Finder拡張の新規ファイル作成機能にて、ファイルの書き込みに必要な権限を取得するための関数。

         */
        let result = self.nsOpenPanelService.runModal(allowsMultipleSelection: false, canChooseFiles: false, canChooseDirectories: false, directoryPath: NSHomeDirectory())
        if result == .cancel {
            return
        }
        else if result != .OK {
            self.nsAlertService.showAlert(title: "エラー", message: "何らかのエラーが発生しました。再度実行してください。")
            return
        }
        // NSOpenPanelのbeginを非同期処理で扱う
        do {
            let url = try self.nsOpenPanelService.getSecureBookMarkUrl()
            let bookMarkData = try self.nsOpenPanelService.getBookmarkData()
            let allowed_url = url.components(separatedBy: "/")
            let home_url_array = NSHomeDirectory().components(separatedBy: "/")[0 ... 2]

            if allowed_url.prefix(3) != home_url_array {
                // 現段階ではホームディレクトリ以外での書き込み動作は対象外であるため、他のディレクトリが指定された場合は弾く
                throw SaveSecureBookMarkError.unsupportedDirectory
            } else if allowed_url.count > 4 {
                // allowed_urlの個数が3より多い場合、ホームディレクトリ下のなにかのフォルダを指定していることになるため、パーミッションとしては小さい
                let userResult = self.nsAlertService.showAlertWithUserSelect(title: "権限が小さいです", message: "ホームディレクトリより下のフォルダが指定されました。一部のフォルダでは正常に動作しない可能性があります。よろしいですか？")
                guard userResult else { return }
                try self.secureBookMarkService.saveSecureBookMark(bookmark: bookMarkData)
            }
        }
        catch {
            if case let error as SaveSecureBookMarkError = error {
                self.nsAlertService.showAlert(
                    title: error.title,
                    message: error.message
                )
            } else {
                // 本来はここに来ることはないはず
                self.nsAlertService.showAlert(
                    title: "不明なエラー",
                    message: "不明なエラーが発生しました。再度実行してください。"
                )
            }
        }
    }

    func callBack() async {
        await self.saveSecureBookMark()
    }
}
