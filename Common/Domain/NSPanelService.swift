import AppKit
import Combine
import SwiftUI
struct NSPanelService: NSPanelServiceProtocol {

    @MainActor
    static func createPanel<ContentVM: NSPanelManagementViewModelProtocol, V: View>(view: V, viewModel:ContentVM, isfocused: Bool = false, x: Int = 600, y: Int = 400, width: Int = 300, height: Int = 200) {
        let newPanel = NSPanel(
            contentRect: NSRect(x: x, y: y, width: width, height: height),
            styleMask: [.nonactivatingPanel, .titled, .hudWindow],
            backing: .buffered,
            defer: false
        )
        newPanel.title = ContentVM.title
        newPanel.isFloatingPanel = true
        newPanel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        newPanel.contentView = NSHostingView(rootView: view)
        newPanel.isReleasedWhenClosed = true
        if isfocused {
            newPanel.level = .floating
            newPanel.makeKeyAndOrderFront(nil)
        } else {
            newPanel.orderFront(nil)
        }
    }

}
