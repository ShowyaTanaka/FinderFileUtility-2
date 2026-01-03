import Combine
import SwiftUI
protocol NSPanelManagementView: View {
    associatedtype VM: NSPanelManagementViewModelProtocol
    var viewModel: VM {get}
    init(viewModel: VM)
}
protocol NSPanelManagementViewModelProtocol: AnyObject {
    associatedtype NSPanelView: NSPanelManagementView
    static var viewType: NSPanelView.Type { get }
    static var title: String {get}
    var panelService: NSPanelServiceProtocol.Type? {get set}
    var panel: NSPanel? {get set}

}
extension NSPanelManagementViewModelProtocol {
    func closeWindow() {
        guard let selfPanel = panel,
        let panelManagementService = self.panelService else {NSLog("deinited!"); return}
        panelManagementService.closeWindow(panel: selfPanel)
    }
}
