//
//  FinderSync.swift
//  FFU2 Extension
//
//  Created by ShowyaTanaka on 2024/11/18.
//

import Cocoa
import FinderSync

class FinderSync: FIFinderSync {
    private let keyForAvailableDirectory = "availableDirectory"
    var myFolderURL = URL(fileURLWithPath: "")

    override init() {
        NSLog("FinderSync() launched from %@", Bundle.main.bundlePath as NSString)
        if let userDefaults = UserDefaults(suiteName: "group.com.ShoyaTanaka.FFU2") {
            if let directoryPath = userDefaults.string(forKey: self.keyForAvailableDirectory) {
                self.myFolderURL = URL(fileURLWithPath: directoryPath)
            }
        }
        super.init()
        NSLog("FinderSync() launched from %@", Bundle.main.bundlePath as NSString)

        // Set up the directory we are syncing.
        FIFinderSyncController.default().directoryURLs = [self.myFolderURL]

    }

    override func menu(for _: FIMenuKind) -> NSMenu {
        // Produce a menu for the extension.
        let main = NSMenu()
        let submenu = NSMenu()
        let mainDropdown = NSMenuItem(title: "Create File", action: nil, keyEquivalent: "")
        let extensionArray = FileExtensionService.getRegisteredExtension()
        main.addItem(mainDropdown)
        main.setSubmenu(submenu, for: mainDropdown)

        for fileExtension in extensionArray {
            submenu.addItem(NSMenuItem(title: fileExtension, action: #selector(createFileAction(_:)), keyEquivalent: ""))
        }
        return main
    }

    @IBAction func createFileAction(_ sender: AnyObject?) {
        let target = FIFinderSyncController.default().targetedURL()
        guard let targetURL = target else {NSLog("URLがないです"); return}
        guard let item = sender as? NSMenuItem else {NSLog("NSMenuItemを作れませんでした."); return}
        var selectedExt = item.title
        if selectedExt.starts(with: ".") {
            let startIndex = selectedExt.index(after: selectedExt.startIndex)
            selectedExt = String(selectedExt[startIndex...])
        }
        let sendObj = ["selected_extension": selectedExt, "path": targetURL.path().removingPercentEncoding]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: sendObj, options: []) else {NSLog("sendObjをjsonにできませんでした。"); return}
        let portName = "group.com.ShoyaTanaka.FFU2.editfile" as CFString

        // 2. CFMessagePortCreateRemoteでリモートポート（送信先）への参照を取得
        guard let remotePort = CFMessagePortCreateRemote(nil, portName) else {
            NSLog("送信エラー: ポートに接続できません。受信側のアプリは起動していますか？")
            return
        }
        let jsonString = String(data: jsonData, encoding: .utf8)!
        // 3. 送信するデータをCFDataに変換する
        guard let data = jsonString.data(using: .utf8) as CFData? else {
            NSLog("送信エラー: データの変換に失敗しました。")
            return
        }

        // 4. CFMessagePortSendRequestでメッセージを送信
        let timeout: TimeInterval = 5.0 // タイムアウト時間（秒）
        var returnData: Unmanaged<CFData>? // 応答データを受け取るためのポインタ

        _ = CFMessagePortSendRequest(
            remotePort,      // 送信先ポート
            0,               // Message ID (任意)
            data,            // 送信するデータ
            timeout,         // 送信タイムアウト
            timeout,         // 応答受信タイムアウト
            nil,             // 応答データを受け取るためのRunLoopモード (今回は応答を待たないためnil)
            &returnData
        )
    }
}
