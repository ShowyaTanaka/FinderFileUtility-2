//
//  NewFileWindowManager.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/09/24.
//
import SwiftUI

@MainActor
class EditFileViewWindowInformationService: NSObject{
    
    /*
     EditFileViewWindow用に独自拡張したもの。
     ここでは,標準的なウィンドウ管理周辺情報のほか,CFNotificationCenterGetDarwinNotifyCenterを用いたcallback処理も分担している。
     */
    
    @objc private func fileNameNotificationCallBack(notification: Notification) {
        guard let object = notification.object as? [String:Any] else {return}
        guard let path = object["path"] as? String else {return}
        guard let selectedExtension = object["selected_extension"] as? String else {return}
        
        let viewModel = CreateFileViewModel(currentDirURL: URL(fileURLWithPath: path), selectedExtension: selectedExtension)
        let panelService = NSPanelManagementService(view: CreateFileView(viewModel: viewModel))
        panelService.openWindow(isfocused: true, title: "新規ファイル作成")
    }
    init(isShowWindow: Bool) {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(fileNameNotificationCallBack), name: .notifyEditFileName, object: nil)
    }

}
 

