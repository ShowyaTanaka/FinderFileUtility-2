//
//  ConfigMenuViewModel.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2024/11/19.
//

import FinderSync
import Observation

private enum SaveSecureBookMarkStatus {
    // ConfigMenuModelのsaveSecureBookMarkForHomeDirectoryの結果を示す
    case ok
    case unsupporeted_directory // 現状ホームディレクトリ以外が指定された場合はこれを返す
    case smaller_permission_for_home_directory //ホームディレクトリの中でさらに小さいフォルダ(ex./home/hoge/fugaのfuga)が指定されたとき返す
    case canceled // 中断した場合これ
    case failed // 何らかの要因で失敗した場合これを返す
}
private struct SaveSecureBookMarkResult {
    var bookmark: Data? = nil
    var status: SaveSecureBookMarkStatus = .failed
}

@Observable class ConfigMenuViewModel {
    var isEnableFinderExtension: Bool
    var allowedDirectory: String?
    
    init() {
        self.isEnableFinderExtension = FIFinderSyncController.isExtensionEnabled
        self.allowedDirectory = SecureBookMarkModel.getSecureBookMarkStringFullPath()
    }
    
    private func showAlert(title: String, message: String){
        /*
         ユーザーの選択肢無しでアラートを表示する。
         */
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        _ = alert.runModal()
    }
    
    private func showAlertWithUserSelect(title: String, message: String) -> Bool {
        /*
         ユーザーが選択できるアラートを表示する。
         OKが押された場合はtrueを、それ以外ならfalseを返す。
         */
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        alert.buttons[0].tag = NSApplication.ModalResponse.OK.rawValue
        alert.addButton(withTitle: "キャンセル")
        alert.buttons[1].tag = NSApplication.ModalResponse.cancel.rawValue
        let result = alert.runModal()
        if result == .OK {
            return true
        }
        else {
            return false
        }
    }
    
    
    @MainActor // NSWindowがいるので主スレッド指定
    func saveSecureBookMark() async {
        /*
         Finder拡張の新規ファイル作成機能にて、ファイルの書き込みに必要な権限を取得するための関数。
         
         */
        let result: SaveSecureBookMarkResult = await self.createSecureBookMarkForHomeDirectory()

        switch result.status {
            case .ok:
            if SecureBookMarkModel.saveSecureBookMark(bookmark: result.bookmark) {
                    self.allowedDirectory = SecureBookMarkModel.getSecureBookMarkStringFullPath()
                }
                else {
                    self.showAlert(title: "エラー", message: "何らかのエラーが発生しました。再度実行してください。")
                }
            case .unsupporeted_directory:
                self.showAlert(title: "サポートされていないディレクトリ",
                               message: "指定したディレクトリはサポートされていません。ホームディレクトリ、あるいはそれより下の階層を指定してください。")
            case .smaller_permission_for_home_directory:
                let userResult = self.showAlertWithUserSelect(title: "権限が小さいです", message: "ホームディレクトリより下のフォルダが指定されました。一部のフォルダでは正常に動作しない可能性があります。よろしいですか？")
                if userResult {
                    if SecureBookMarkModel.saveSecureBookMark(bookmark: result.bookmark) {
                        self.allowedDirectory = SecureBookMarkModel.getSecureBookMarkStringFullPath()
                    }
                    else {
                        self.showAlert(title: "エラー", message: "何らかのエラーが発生しました。再度実行してください。")
                    }
                }
            case .canceled:
                return
            case .failed:
                self.showAlert(title: "エラー", message: "何らかのエラーが発生しました。再度実行してください。")
        }
    }
    
    @MainActor //UI関係は主スレッドで実行しなければならないため、主スレッドで指定する。(ここではNSOpenPanel)
    private func createSecureBookMarkForHomeDirectory() async -> SaveSecureBookMarkResult {
        /*
         Finder拡張機能のうち、ファイルの新規作成機能を利用する際に必要となる「ファイルの書き込みができるBookMark」を生成、保存する関数。
         */
        var save_result = SaveSecureBookMarkResult()
        let result = await withCheckedContinuation { continuation in

                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseFiles = false
                panel.canChooseDirectories = true
                panel.directoryURL = URL(string: NSHomeDirectory())
                // NSOpenPanelのbeginを非同期処理で扱う
                panel.begin { result in
                    if result == .OK {
                        do {
                            let bookmarkData = try panel.url!.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                            var unused_status = false // 入れないと怒られるから入れただけで無意味である。
                            let url = try! URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, bookmarkDataIsStale: &unused_status)
                            let allowed_url = url.path().components(separatedBy: "/")
                            let home_url_array = NSHomeDirectory().components(separatedBy: "/")[0 ... 2]
                            
                            if allowed_url.prefix(3) != home_url_array {
                                // 現段階ではホームディレクトリ以外での書き込み動作は対象外であるため、他のディレクトリが指定された場合は弾く
                                save_result.status = .unsupporeted_directory
                            }
                            
                            else if allowed_url.count > 4 {
                                // allowed_urlの個数が3より多い場合、ホームディレクトリ下のなにかのフォルダを指定していることになるため、パーミッションとしては小さい
                                
                                save_result.status = .smaller_permission_for_home_directory
                                save_result.bookmark = bookmarkData
                            }
                            else {
                                // 正常な場合はokを返す
                                save_result.status = .ok
                                save_result.bookmark = bookmarkData
                            }
                        } catch {
                            save_result.status = .failed
                        }
                    }
                    else if result == .cancel {
                        save_result.status = .canceled
                    }
                    else {
                        save_result.status = .failed
                    }
                    continuation.resume(returning: save_result)
                }
            }

            return result
    }
}
