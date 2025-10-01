//
//  FinderFileUtility_2App.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2024/11/20.
//

import SwiftUI

@main
struct FinderFileUtility_2App: App {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openWindow) private var openWindow
    @StateObject var configViewWindowManager = WindowInformationService(isShowWindow: true)
    @StateObject var editFileViewWindowManager = EditFileViewWindowInformationService(isShowWindow: false, viewModel: EditFileNameViewModel())
    var backgroundThread: Thread?


    var listenerDelegate: EditFileViewWindowInformationListener
   // var listener: NSXPCListener
    init() {
       // _ = EditFileNameCFNotificationCenterService(delegate: editFileViewWindowManager)
        self.listenerDelegate = EditFileViewWindowInformationListener()
       // self.listener = NSXPCListener.service()
        // self.listener.delegate = self.listenerDelegate
        // self.listener.resume()
        let testHandler = CFMessageTestHandler()
        launchMessagePort(cfMessagePortHandler: testHandler)
        
        // スレッドが解放されないように保持しておく
        self.backgroundThread = testHandler.cfMessagePortThread
        

    }
    var body: some Scene {
        WindowGroup(id: "ConfigWindow") {
                ConfigMenuView()
                .onAppear {
                    self.configViewWindowManager.toggleIsShowWindow(shouldBeValue: true)
                }
                .onDisappear {
                    self.configViewWindowManager.toggleIsShowWindow(shouldBeValue: false)
                }
            }
        .onChange(of:self.configViewWindowManager.isShowWindow) {
            if self.configViewWindowManager.isShowWindow {
                openWindow(id: "ConfigWindow")
            }
            else {
                dismissWindow(id: "ConfigWindow")
            }
        }
        
        WindowGroup(id: "NewFileWindow") {
                EditFileNameView(viewModel: self.editFileViewWindowManager.viewModel)
                .onAppear {
                    self.editFileViewWindowManager.toggleIsShowWindow(shouldBeValue: true)
                }
                .onDisappear {
                    self.editFileViewWindowManager.toggleIsShowWindow(shouldBeValue: false)
                }
        }
        .onChange(of:self.editFileViewWindowManager.isShowWindow) {
            if self.editFileViewWindowManager.isShowWindow {
                openWindow(id: "NewFileWindow")
            }
            else {
                dismissWindow(id: "NewFileWindow")
            }
        }
    }

}

