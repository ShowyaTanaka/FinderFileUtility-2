import Combine
import SwiftUI
protocol NSPanelManagementView: View {
    associatedtype VM: NSPanelManagementViewModelProtocol
    var viewModel: VM {get}
    init(viewModel: VM)
}
protocol NSPanelManagementViewModelProtocol: AnyObject {
    associatedtype MView: NSPanelManagementView
    static var viewType: MView.Type { get }
    static var title: String {get}
    var windowController: NSPanelController? {get set}
}

extension NSPanelManagementViewModelProtocol {
    func closeWindow() {
        if let windowController = self.windowController {
            print("HHH")
            windowController.close()
            self.windowController = nil
        }
        else {
            print("BBB")
        }
    }
}
