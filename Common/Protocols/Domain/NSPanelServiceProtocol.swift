import Cocoa

protocol NSPanelServiceProtocol{
    static func createPanel<ContentVM: NSPanelManagementViewModelProtocol>(viewModel: ContentVM, isfocused: Bool, x: Int, y: Int, width: Int, height: Int)
    static func closeWindow(panel: NSPanel)
}
