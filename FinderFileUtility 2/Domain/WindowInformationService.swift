//
//  NewFileWindowManager.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/09/24.
//
import SwiftUI

@MainActor
protocol WindowManagementProtocol: ObservableObject {
    var isShowWindow: Bool {get set}
    func toggleIsShowWindow(shouldBeValue: Bool?)
}

extension WindowManagementProtocol {
    func toggleIsShowWindow() {
        toggleIsShowWindow(shouldBeValue: nil)
    }
}

class WindowInformationService: WindowManagementProtocol {
    @Published var isShowWindow : Bool
    func toggleIsShowWindow(shouldBeValue: Bool?) {
        if let shoudBeToggle = shouldBeValue {
            self.isShowWindow = shoudBeToggle
        }
        else {
            self.isShowWindow.toggle()
        }
    }
    init(isShowWindow: Bool) {
        self.isShowWindow = isShowWindow
    }
}

class EditFileViewWindowInformationService: NSObject, WindowManagementProtocol{
    
    /*
     EditFileViewWindow用に独自拡張したもの。
     ここでは,標準的なウィンドウ管理周辺情報のほか,CFNotificationCenterGetDarwinNotifyCenterを用いたcallback処理も分担している。
     */
    @Published var isShowWindow : Bool
    var viewModel: EditFileNameViewModel
    
    func toggleIsShowWindow(shouldBeValue: Bool?) {
        if let shouldBeToggle = shouldBeValue {
            self.isShowWindow = shouldBeToggle
        }
        else {
            self.isShowWindow.toggle()
        }
    }
    @objc private func fileNameNotificationCallBack(notification: Notification) {
        guard let object = notification.object as? [String:Any] else {return}
        guard let message = object["message"] as? String else {return}
        print("EditFileViewWindowInformationService:\(message)")
        
    }
    init(isShowWindow: Bool, viewModel: EditFileNameViewModel) {
        self.isShowWindow = isShowWindow
        self.viewModel = viewModel
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(fileNameNotificationCallBack), name: .notifyEditFileName, object: nil)
    }

}
class EditFileViewWindowInformationListener:NSObject, EditFileXPCProtocol, NSXPCListenerDelegate {
    @objc func editFileNotification(path: String, ext: String, with reply: @escaping (Bool) -> Void) {
        print("AAAAAA!!!!!")
        /*self.viewModel.currentDirURL = URL(fileURLWithPath: path)
        self.viewModel.selectedExt = ext
        self.toggleIsShowWindow(shouldBeValue: true)*/
        reply(true)
        // パスを検証し,保存できるディレクトリであれば保存を行う.
    }
    func listener(_ listener: NSXPCListener,
        shouldAcceptNewConnection connection: NSXPCConnection) -> Bool {
        connection.exportedInterface = NSXPCInterface(with: EditFileXPCProtocol.self)
        connection.exportedObject = self
        connection.resume()
        return true
    }
}

