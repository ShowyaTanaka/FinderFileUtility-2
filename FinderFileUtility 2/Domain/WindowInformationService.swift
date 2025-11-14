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
        
        guard let path = object["path"] as? String else {return}
        guard let selectedExtension = object["selected_extension"] as? String else {return}
        
        let viewModel = CreateFileViewModel(currentDirURL: URL(fileURLWithPath: path), selectedExtension: selectedExtension)
        let panelService = NSPanelManagementService(view: CreateFileView(viewModel: viewModel))
        
        panelService.openWindow(isfocused: true, title: "新規ファイル作成")
    }
    init(isShowWindow: Bool) {
        self.isShowWindow = isShowWindow
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(fileNameNotificationCallBack), name: .notifyEditFileName, object: nil)
    }

}
 

