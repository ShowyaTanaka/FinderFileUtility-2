import SwiftUI

@main
struct FinderFileUtility_2App: App {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openWindow) private var openWindow
    @StateObject var editFileViewWindowManager = EditFileViewWindowInformationService()
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
        }
    }

}

