//


import SwiftUI
import Foundation

@main
struct FFU2_DaemonApp: App {
    var editFilePipeLine: CFMessagePortToNotificationPipeLine
    var saveBookMarkNotification: DistributedNotificationHandler
    
    init() {
        // PipeLineが解放されないように留めておく。
        self.editFilePipeLine = CFMessagePortToNotificationPipeLine(pipeLineDelegate: NotifyCreateFileView())
        self.saveBookMarkNotification = DistributedNotificationHandler(delegate: FileSecureBookMark())
        _ = self.editFilePipeLine.launchMessagePort()
    }
    var body: some Scene {
        
    }
}
