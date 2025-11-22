import SwiftUI

@main
struct FinderFileUtility_2App: App {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openWindow) private var openWindow
    var editFilePipeLine: CFMessagePortToNotificationPipeLine

    init() {
        // PipeLineが解放されないように留めておく。
        self.editFilePipeLine = CFMessagePortToNotificationPipeLine(pipeLineDelegate: NotifyCreateFileView())
        let _ = self.editFilePipeLine.launchMessagePort()
    }
    var body: some Scene {
        WindowGroup(id: "ConfigWindow") {
                ConfigMenuView()
        }
    }

}

