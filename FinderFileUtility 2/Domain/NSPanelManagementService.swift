//
//  NSPanelManagementService.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/11/09.
//
import SwiftUI
import Combine
class NSPanelManagementService<Content: NSPanelManagementView>:ObservableObject {
    var panel: NSPanel?
    var view: Content
    private var cancellables = Set<AnyCancellable>()
    
    init(view: Content) {
        self.view = view
        self.view.isCloseWindow.$isClose.sink { recieveComplete in
            print(recieveComplete)
            print("detect")

        } receiveValue: { isCloseWindow in
            print("detect recieve")
            print(isCloseWindow)
            if isCloseWindow{
                self.closeWindow()
            }
        }.store(in: &cancellables)
    }
    
    func closeWindow() {
        DispatchQueue.main.async {
            if let panel = self.panel {
                panel.close()
            }
        }
    }
    
    func openWindow(isfocused: Bool = false, title: String, x: Int=600, y: Int=400, width: Int=300, height: Int=200){
        DispatchQueue.main.async {
            let panel = NSPanel(
                contentRect: NSRect(x: x, y: y, width: width, height: height),
                styleMask: [.nonactivatingPanel, .titled, .hudWindow],
                backing: .buffered,
                defer: false
            )
            panel.title = title
            panel.isFloatingPanel = true
            panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            panel.contentView = NSHostingView(rootView: self.view)
            if isfocused {
                panel.level = .floating
                panel.makeKeyAndOrderFront(nil)
            }
            self.panel = panel
        }
        
    }
}
