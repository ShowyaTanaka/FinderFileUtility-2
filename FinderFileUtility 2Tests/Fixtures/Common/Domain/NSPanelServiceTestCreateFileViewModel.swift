import Testing
@testable import FinderFileUtility_2

import Cocoa
import Combine
import Foundation
class NSPanelServiceTestCreateFileViewModel: ObservableObject, NSPanelControllerViewModelProtocol {
    var windowController: NSPanelController?
    var isDeinit = false
    deinit { NSLog("TestClass deinit")
        isDeinit = true
    }
    static let title = "新規ファイル作成"
}
