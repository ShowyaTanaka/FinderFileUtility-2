//

import AppKit
import SwiftUI
class ControlledNSPanel {
    var panel: NSPanel?
    
    
    func open<Content: View>(view: Content, isfocused: Bool = false, title: String, x: Int = 600, y: Int = 400, width: Int = 300, height: Int = 200) {
        var panel: NSPanel?
        DispatchQueue.main.async {
            let newPanel = NSPanel(
                contentRect: NSRect(x: x, y: y, width: width, height: height),
                styleMask: [.nonactivatingPanel, .titled, .hudWindow],
                backing: .buffered,
                defer: false
            )
            newPanel.title = title
            newPanel.isFloatingPanel = true
            newPanel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            newPanel.contentView = NSHostingView(rootView: view)
            if isfocused {
                newPanel.level = .floating
                newPanel.makeKeyAndOrderFront(nil)
            }
            panel = newPanel
            if let opened_panel = panel {
                self.panel = opened_panel
            }
        }

    }
    
    func close() {
        DispatchQueue.main.async {
            if let panel = self.panel {
                panel.close()
            }
        }
    }
}

