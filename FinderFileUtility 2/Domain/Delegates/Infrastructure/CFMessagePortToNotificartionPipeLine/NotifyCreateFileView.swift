import Foundation
class NotifyCreateFileView: NSObject, CFMessagePortToNotificationPipeLineDelegate{
    
    /*
     EditFileViewWindow用に独自拡張したもの。
     ここでは,標準的なウィンドウ管理周辺情報のほか,CFNotificationCenterGetDarwinNotifyCenterを用いたcallback処理も分担している。
     */
    var notificationName = Notification.Name("notifyEditFileName")
    var portName = "group.com.ShoyaTanaka.FFU2.editfile" as CFString
    var panelService: NSPanelManagementService<CreateFileView, CreateFileViewModel>?
    
    @objc func callback(notification: Notification) {
        guard let object = notification.object as? [String:Any] else {return}
        guard let path = object["path"] as? String else {return}
        guard let selectedExtension = object["selected_extension"] as? String else {return}
        
        let viewModel = CreateFileViewModel(currentDirURL: URL(fileURLWithPath: path), selectedExtension: selectedExtension)
        let panelService = NSPanelManagementService(view: CreateFileView(viewModel: viewModel), viewModel: viewModel)
        self.panelService = panelService
        panelService.openWindow(isfocused: true, title: "新規ファイル作成")
    }
    
    var callBackSelector:Selector {
        return #selector(self.callback(notification:))
    }

}
 

