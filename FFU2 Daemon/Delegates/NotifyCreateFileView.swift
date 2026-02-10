import Foundation
class NotifyCreateFileView: NSObject, CFMessagePortToNotificationHandlerDelegate {

    /*
     EditFileViewWindow用に独自拡張したもの。
     ここでは,標準的なウィンドウ管理周辺情報のほか,CFNotificationCenterGetDarwinNotifyCenterを用いたcallback処理も分担している。
     */
    var notificationName = Notification.Name("notifyEditFileName")
    var portName = "group.com.ShoyaTanaka.FFU2.editfile" as CFString
    var nsPanelControllerType: NSPanelController.Type
    var view: CreateFileView?
    init(nsPanelControllerType: NSPanelController.Type = NSPanelController.self) {
        self.nsPanelControllerType = nsPanelControllerType
    }

    @objc func callback(notification: Notification) {
        guard let object = notification.object as? [String: Any] else {return}
        guard let path = object["path"] as? String else {return}
        guard let selectedExtension = object["selected_extension"] as? String else {return}
        let fileNameService = fileNameServiceFactory()

        let viewModel = CreateFileViewModel(currentDirURL: URL(fileURLWithPath: path), selectedExtension: selectedExtension, fileNameService: fileNameService, fileManagementService: FileManagementService(fileNameService: fileNameService))
        let view = CreateFileView(viewModel: viewModel)
        Task {
            await self.nsPanelControllerType.init(viewModel: viewModel, view: view, isfocused: true, x: 600, y: 400, width: 300, height: 200)
        }
    }

    var callBackSelector: Selector {
        return #selector(self.callback(notification:))
    }

}
