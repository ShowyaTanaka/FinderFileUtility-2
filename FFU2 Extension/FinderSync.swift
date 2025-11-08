//
//  FinderSync.swift
//  FFU2 Extension
//
//  Created by ShowyaTanaka on 2024/11/18.
//

import Cocoa
import FinderSync
import SwiftUI
// TODO: XPCを用いてアプリ側にターゲットディレクトリの情報を送り、アプリ側からそこに読み書きする形へ。

class FinderSync: FIFinderSync {
    private let keyForAvailableDirectory = "availableDirectory"
    var myFolderURL = URL(fileURLWithPath: "")
    
    override init() {
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

    // MARK: - Primary Finder Sync protocol methods

    override func beginObservingDirectory(at url: URL) {
        // The user is now seeing the container's contents.
        // If they see it in more than one view at a time, we're only told once.
        NSLog("beginObservingDirectoryAtURL: %@", url.path as NSString)
    }

    override func endObservingDirectory(at url: URL) {
        // The user is no longer seeing the container's contents.
        NSLog("endObservingDirectoryAtURL: %@", url.path as NSString)
    }

    override func requestBadgeIdentifier(for url: URL) {
        NSLog("requestBadgeIdentifierForURL: %@", url.path as NSString)

        // For demonstration purposes, this picks one of our two badges, or no badge at all, based on the filename.
        let whichBadge = abs(url.path.hash) % 3
        let badgeIdentifier = ["", "One", "Two"][whichBadge]
        FIFinderSyncController.default().setBadgeIdentifier(badgeIdentifier, for: url)
    }

    // MARK: - Menu and toolbar item support

    override var toolbarItemName: String {
        return "FinderSy"
    }

    override var toolbarItemToolTip: String {
        return "FinderSy: Click the toolbar item for a menu."
    }

    override var toolbarItemImage: NSImage {
        return NSImage(named: NSImage.cautionName)!
    }

    override func menu(for _: FIMenuKind) -> NSMenu {
        // Produce a menu for the extension.
        let menu = NSMenu(title: "")
        menu.addItem(withTitle: "Example Menu Item", action: #selector(sampleAction(_:)), keyEquivalent: "")
        return menu
    }

    @IBAction func sampleAction(_ sender: AnyObject?) {
        let target = FIFinderSyncController.default().targetedURL()
        let items = FIFinderSyncController.default().selectedItemURLs()
        guard let targetURL = target else {return}
        let item = sender as! NSMenuItem
        let selectedExt = item.title
        /*
        let editFileNameViewModel = EditFileNameViewModel(currentDirURL: targetURL, selectedExt: item.title)
        let editFileNameView = EditFileNameView(viewModel: editFileNameViewModel)
        NSLog("AAAA")
        DispatchQueue.main.async{
            let controller = MyViewController(
                rootView: editFileNameView,
            
            )

            let win = NSWindow(
                contentViewController: controller
            )
            win.title = "新規ファイル作成"
            win.styleMask = [.titled, .closable, .resizable] // 必要に応じて
            win.center()

            // ウィンドウレベルを「常に前面」に設定
            win.level = .floating

            // アプリを最前面にアクティブ化
            NSApp.activate(ignoringOtherApps: true)
            // フォーカスを持たせる（KeyWindow にする）
            win.makeKeyAndOrderFront(nil)
            win.becomeMain()   // メインウィンドウにする
            win.makeFirstResponder(win.contentView) // TextField などに入力できるように
        }
         */
        func sendNotification(path: String, ext: String) {
            let connection = NSXPCConnection(serviceName: "ShowyaTanaka.FinderFileUtility-2")
            connection.remoteObjectInterface = NSXPCInterface(with: EditFileXPCProtocol.self)
            connection.activate()
            guard let proxy = connection.remoteObjectProxy as? EditFileXPCProtocol else {return}
                proxy.editFileNotification(path: path, ext: ext)  {reply in
                    if reply == true {
                        NSLog("Success!")
                    }
                    
                }

           // connection.invalidate()
        }
        
        NSLog("sampleAction: menu item: %@, target = %@, items = ", item.title as NSString, target!.path as NSString)
        for obj in items! {
            NSLog("    %@", obj.path as NSString)
        }
        /*let center = CFNotificationCenterGetDarwinNotifyCenter()
        let userInfo: [CFString: Any] = [
            "path" as CFString: target!.path as CFString,
            "target_ext" as CFString: item.title as CFString
        ]
        let notify_name = CFNotificationName("com.FFU2.EditFile" as CFString)
        CFNotificationCenterPostNotification(
            center,
            notify_name,
            nil,
            userInfo as CFDictionary,
            true
        )*/
        sendNotification(path: target!.path, ext: item.title)
        let portName = "group.com.ShoyaTanaka.FFU2.editfile" as CFString
        let message = "hoge"
        
        // 2. CFMessagePortCreateRemoteでリモートポート（送信先）への参照を取得
        guard let remotePort = CFMessagePortCreateRemote(nil, portName) else {
            NSLog("送信エラー: ポートに接続できません。受信側のアプリは起動していますか？")
            return
        }
        
        // 3. 送信するデータをCFDataに変換する
        guard let data = message.data(using: .utf8) as CFData? else {
            print("送信エラー: データの変換に失敗しました。")
            return
        }
        
        print("メッセージを送信します: \(message)")
        
        // 4. CFMessagePortSendRequestでメッセージを送信
        let timeout: TimeInterval = 5.0 // タイムアウト時間（秒）
        var returnData: Unmanaged<CFData>? = nil // 応答データを受け取るためのポインタ

        let status = CFMessagePortSendRequest(
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
