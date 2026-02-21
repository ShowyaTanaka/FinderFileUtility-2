//

import Foundation
import SwiftUI

@main
struct FFU2_DaemonApp: App {
    var editFilePipeLine: CFMessagePortToNotificationHandler
    var saveBookMarkNotification: DistributedNotificationHandler?

    var isRunningTests: Bool {
        let env = ProcessInfo.processInfo.environment
        // Xcode / xcodebuild の unit test でよく立つ
        if env["XCTestConfigurationFilePath"] != nil { return true }  // :contentReference[oaicite:1]{index=1}
        // Swift Testing でも見えることがある（環境差あり）
        if env["XCTestSessionIdentifier"] != nil { return true }      // :contentReference[oaicite:2]{index=2}
        return false
    }

    init() {
        // PipeLineが解放されないように留めておく。
        self.editFilePipeLine = CFMessagePortToNotificationHandler(pipeLineDelegate: NotifyCreateFileView())
        let secureBookMarkService = secureBookMarkServiceFactory()
        if !secureBookMarkService.isBookMarkExists() {
            // SecureBookMarkが存在しない場合は,ユーザー側からSecureBookmarkの保存要求が飛んでくる可能性があるため、インスタンスを作成する。
            self.saveBookMarkNotification = DistributedNotificationHandler(delegate: FileSecureBookMark(secureBookMarkService: secureBookMarkService, nsOpenPanelService: NSOpenPanelService()))
        }
        if !self.isRunningTests {
            _ = self.editFilePipeLine.launchMessagePort()
        }
        UserDefaultsModel().setValue(value: secureBookMarkService.isBookMarkExists(), forKey: UserDefaultsKey.isSecureBookMarkValidKey)
    }
    var body: some Scene {

    }
}
