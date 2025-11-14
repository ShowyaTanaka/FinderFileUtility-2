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
    @StateObject var editFileViewWindowManager = EditFileViewWindowInformationService(isShowWindow: false)
    var editFilePipeLine: CFMessagePortToNotificationPipeLineService

    init() {
        let editFilePipeLineInfo = CFMessagePortEditFilePipeLineInformation()
        // PipeLineが解放されないように留めておく。
        self.editFilePipeLine = CFMessagePortToNotificationPipeLineService(pipeLineInfo: editFilePipeLineInfo)
        let _ = self.editFilePipeLine.launchMessagePort()
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
        }
        .onChange(of:self.editFileViewWindowManager.isShowWindow) {
            print("AAAAAAA")
            if self.editFileViewWindowManager.isShowWindow {
                
                // createPanel()
            }
        }
    }

}

