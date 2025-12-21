import Foundation
class NotifyCreateFileView: NSObject, CFMessagePortToNotificationHandlerDelegate {

    /*
     EditFileViewWindow用に独自拡張したもの。
     ここでは,標準的なウィンドウ管理周辺情報のほか,CFNotificationCenterGetDarwinNotifyCenterを用いたcallback処理も分担している。
     */
    var notificationName = Notification.Name("notifyEditFileName")
    var portName = "group.com.ShoyaTanaka.FFU2.editfile" as CFString

    @objc func callback(notification: Notification) {
        guard let object = notification.object as? [String: Any] else {return}
        guard let path = object["path"] as? String else {return}
        guard let selectedExtension = object["selected_extension"] as? String else {return}

        let viewModel = CreateFileViewModel(currentDirURL: URL(fileURLWithPath: path), selectedExtension: selectedExtension)
        NSPanelService.createPanel(viewModel: viewModel, isfocused: true)

    }

    var callBackSelector: Selector {
        return #selector(self.callback(notification:))
    }

}
