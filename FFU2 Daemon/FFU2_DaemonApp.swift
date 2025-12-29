//

import Foundation
import SwiftUI

@main
struct FFU2_DaemonApp: App {
    var editFilePipeLine: CFMessagePortToNotificationHandler
    var saveBookMarkNotification: DistributedNotificationHandler?

    init() {
        // PipeLineが解放されないように留めておく。
        self.editFilePipeLine = CFMessagePortToNotificationHandler(pipeLineDelegate: NotifyCreateFileView())
        let secureBookMarkService = secureBookMarkServiceFactory()
        if !secureBookMarkService.isBookMarkExists(){
            // SecureBookMarkが存在しない場合は,ユーザー側からSecureBookmarkの保存要求が飛んでくる可能性があるため、インスタンスを作成する。
            self.saveBookMarkNotification = DistributedNotificationHandler(delegate: FileSecureBookMark(secureBookMarkService: secureBookMarkService, nsOpenPanelService: NSOpenPanelService()))
        }
        _ = self.editFilePipeLine.launchMessagePort()
    }
    var body: some Scene {

    }
}
