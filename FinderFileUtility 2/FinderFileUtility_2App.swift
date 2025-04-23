//
//  FinderFileUtility_2App.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2024/11/20.
//

import SwiftUI

class NotificationHandler: ObservableObject {
    var notificationCenter = DistributedNotificationCenter.default()
    init() {
        // アプリの起動時に通知の監視を開始
        notificationCenter.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("com.ShowyaTanaka.FFU2"), object: nil)
    }
    // 通知を受け取るメソッド
    @objc func handleNotification(_ notification: Notification) {
        print("通知を受信しました: \(notification.name.rawValue)")
        // ここで通知を受け取ったときの処理を行う
    }
}

@main
struct FinderFileUtility_2App: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var notificationHandler = NotificationHandler()
    
    @State private var isUIVisible = false
    var body: some Scene {
        WindowGroup {
            if isUIVisible{
                ConfigMenuView()
            }
            else {
                EmptyView()
            }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                isUIVisible = true
            }
        }
    }

}
