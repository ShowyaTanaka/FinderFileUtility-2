import Combine
import SwiftUI
protocol NSPanelControllerViewModelProtocol: AnyObject {
    static var title: String {get}
    var windowController: NSPanelController? {get set}
}

extension NSPanelControllerViewModelProtocol {
    func closeWindow() {
        if let windowController = self.windowController {
            windowController.close()
            self.windowController = nil
        }
    }
}
