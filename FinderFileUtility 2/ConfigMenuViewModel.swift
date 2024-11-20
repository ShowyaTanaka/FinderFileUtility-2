//
//  ConfigMenuViewModel.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2024/11/19.
//

import FinderSync
import Observation

@Observable class ConfigMenuViewModel {
    var isEnableFinderExtension: Bool
    var allowedDirectory: String?
    
    init() {
        self.isEnableFinderExtension = FIFinderSyncController.isExtensionEnabled
        self.allowedDirectory = SecureBookMarkModel.getSecureBookMarkStringUrl()
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
        let result: SaveSecureBookMarkResult = await SecureBookMarkModel.createSecureBookMarkForHomeDirectory()

        switch result.status {
            case .ok:
                if SecureBookMarkModel.saveSecureBookMark(bookmarkResult: result) {
                    self.allowedDirectory = SecureBookMarkModel.getSecureBookMarkStringUrl()
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
                    if SecureBookMarkModel.saveSecureBookMark(bookmarkResult: result) {
                        self.allowedDirectory = SecureBookMarkModel.getSecureBookMarkStringUrl()
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
}
