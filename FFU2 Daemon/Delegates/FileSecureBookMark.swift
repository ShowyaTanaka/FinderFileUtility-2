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
    deinit {
        NSLog("FileSecureBookMark deinited")
    }

    @MainActor // NSWindowがいるので主スレッド指定
    func saveSecureBookMark() async {
        /*
         Finder拡張の新規ファイル作成機能にて、ファイルの書き込みに必要な権限を取得するための関数。

         */
        var save_result = SaveSecureBookMarkResult()
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.directoryURL = URL(string: NSHomeDirectory())
        let result = panel.runModal()
        // NSOpenPanelのbeginを非同期処理で扱う
        if result == .OK {
            do {
                let bookmarkData = try panel.url!.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                var unused_status = false // 入れないと怒られるから入れただけで無意味である。
                guard let url = try? URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, bookmarkDataIsStale: &unused_status) else {
                    NSAlertService.showAlert(title: "BookMarkエラー", message: "Security Scoped Bookmarkを取得できませんでした。")
                    return
                }
                let allowed_url = url.path().components(separatedBy: "/")
                let home_url_array = NSHomeDirectory().components(separatedBy: "/")[0 ... 2]

                if allowed_url.prefix(3) != home_url_array {
                    // 現段階ではホームディレクトリ以外での書き込み動作は対象外であるため、他のディレクトリが指定された場合は弾く
                    save_result.status = .unsupporeted_directory
                } else if allowed_url.count > 4 {
                    // allowed_urlの個数が3より多い場合、ホームディレクトリ下のなにかのフォルダを指定していることになるため、パーミッションとしては小さい

                    save_result.status = .smaller_permission_for_home_directory
                    save_result.bookmark = bookmarkData
                } else {
                    // 正常な場合はokを返す
                    save_result.status = .ok
                    save_result.bookmark = bookmarkData
                }
            } catch {
                save_result.status = .failed
            }
        } else if result == .cancel {
            save_result.status = .canceled
        } else {
            save_result.status = .failed
        }

        switch save_result.status {
        case .ok:
            if !SecureBookMarkService.saveSecureBookMark(bookmark: save_result.bookmark) {
                NSAlertService.showAlert(title: "エラー", message: "何らかのエラーが発生しました。再度実行してください。")
            }
        case .unsupporeted_directory:
            NSAlertService.showAlert(title: "サポートされていないディレクトリ",
                           message: "指定したディレクトリはサポートされていません。ホームディレクトリ、あるいはそれより下の階層を指定してください。")
        case .smaller_permission_for_home_directory:
            let userResult = NSAlertService.showAlertWithUserSelect(title: "権限が小さいです", message: "ホームディレクトリより下のフォルダが指定されました。一部のフォルダでは正常に動作しない可能性があります。よろしいですか？")
            if userResult {
                if !SecureBookMarkService.saveSecureBookMark(bookmark: save_result.bookmark) {
                    NSAlertService.showAlert(title: "エラー", message: "何らかのエラーが発生しました。再度実行してください。")
                }
            }
        case .canceled:
            return
        case .failed:
            NSAlertService.showAlert(title: "エラー", message: "何らかのエラーが発生しました。再度実行してください。")
        }
    }

    func callBack() async {
        await self.saveSecureBookMark()
    }
}
