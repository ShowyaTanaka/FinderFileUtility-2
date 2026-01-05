import SwiftUI

final class NSPanelController: NSWindowController, NSWindowDelegate {

    init<ContentVM: NSPanelControllerViewModelProtocol, viewInstance: View>(viewModel: ContentVM,view: viewInstance, isfocused: Bool = false, x: Int = 600, y: Int = 400, width: Int = 300, height: Int = 200) {
        let panel = NSPanel(
            contentRect: NSRect(x: x, y: y, width: width, height: height),
            styleMask: [.titled, .closable, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        panel.contentView = NSHostingView(rootView: view)
        panel.isReleasedWhenClosed = true
        if isfocused {
            panel.level = .floating
            panel.makeKeyAndOrderFront(nil)
        } else {
            panel.orderFront(nil)
        }
        super.init(window: panel)
        viewModel.windowController = self
        panel.delegate = self
    }
    func windowWillClose(_ notification: Notification) {
        window?.contentView = nil   // SwiftUI を切る
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
