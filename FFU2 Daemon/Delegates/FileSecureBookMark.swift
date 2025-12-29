import Cocoa
import Foundation

private enum SaveSecureBookMarkStatus {
    // ConfigMenuModelのsaveSecureBookMarkForHomeDirectoryの結果を示す
    case ok
    case unsupporeted_directory // 現状ホームディレクトリ以外が指定された場合はこれを返す
    case smaller_permission_for_home_directory // ホームディレクトリの中でさらに小さいフォルダ(ex./home/hoge/fugaのfuga)が指定されたとき返す
    case canceled // 中断した場合これ
    case failed // 何らかの要因で失敗した場合これを返す
}
private struct SaveSecureBookMarkResult {
    var bookmark: Data?
    var status: SaveSecureBookMarkStatus = .failed
}

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
        var save_result = SaveSecureBookMarkResult()
        let result = self.nsOpenPanelService.runModal(allowsMultipleSelection: false, canChooseFiles: false, canChooseDirectories: false, directoryPath: NSHomeDirectory())
        // NSOpenPanelのbeginを非同期処理で扱う
        if result == .OK {
            do {
                let url = try self.nsOpenPanelService.getSecureBookMarkUrl()
                let bookMarkData = try self.nsOpenPanelService.getBookmarkData()
                let allowed_url = url.components(separatedBy: "/")
                let home_url_array = NSHomeDirectory().components(separatedBy: "/")[0 ... 2]

                if allowed_url.prefix(3) != home_url_array {
                    // 現段階ではホームディレクトリ以外での書き込み動作は対象外であるため、他のディレクトリが指定された場合は弾く
                    save_result.status = .unsupporeted_directory
                } else if allowed_url.count > 4 {
                    // allowed_urlの個数が3より多い場合、ホームディレクトリ下のなにかのフォルダを指定していることになるため、パーミッションとしては小さい

                    save_result.status = .smaller_permission_for_home_directory
                    save_result.bookmark = bookMarkData
                } else {
                    // 正常な場合はokを返す
                    save_result.status = .ok
                    save_result.bookmark = bookMarkData
                }
            } catch let error {
                self.nsAlertService.showAlert(title: "エラー", message: "エラーが発生しました。\(error)")
                save_result.status = .failed
            }
        } else if result == .cancel {
            save_result.status = .canceled
        } else {
            self.nsAlertService.showAlert(title: "エラー", message: "何らかのエラーが発生しました。再度実行してください。")
            save_result.status = .failed
        }

        switch save_result.status {
        case .ok:
            if !self.secureBookMarkService.saveSecureBookMark(bookmark: save_result.bookmark) {
                self.nsAlertService.showAlert(title: "エラー", message: "何らかのエラーが発生しました。再度実行してください。")
            }
        case .unsupporeted_directory:
            self.nsAlertService.showAlert(title: "サポートされていないディレクトリ",
                           message: "指定したディレクトリはサポートされていません。ホームディレクトリ、あるいはそれより下の階層を指定してください。")
        case .smaller_permission_for_home_directory:
            let userResult = self.nsAlertService.showAlertWithUserSelect(title: "権限が小さいです", message: "ホームディレクトリより下のフォルダが指定されました。一部のフォルダでは正常に動作しない可能性があります。よろしいですか？")
            if userResult {
                if !self.secureBookMarkService.saveSecureBookMark(bookmark: save_result.bookmark) {
                    self.nsAlertService.showAlert(title: "エラー", message: "何らかのエラーが発生しました。再度実行してください。")
                }
            }
        case .canceled:
            return
        case .failed:
            return
        }
    }

    func callBack() async {
        await self.saveSecureBookMark()
    }
}
