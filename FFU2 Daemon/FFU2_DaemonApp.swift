//

import Foundation
import SwiftUI

@main
struct FFU2_DaemonApp: App {
    var editFilePipeLine: CFMessagePortToNotificationHandler
    var saveBookMarkNotification: DistributedNotificationHandler

    init() {
        // PipeLineが解放されないように留めておく。
        self.editFilePipeLine = CFMessagePortToNotificationHandler(pipeLineDelegate: NotifyCreateFileView())
        self.saveBookMarkNotification = DistributedNotificationHandler(delegate: FileSecureBookMark())
        _ = self.editFilePipeLine.launchMessagePort()
    }
    var body: some Scene {

    }
}
