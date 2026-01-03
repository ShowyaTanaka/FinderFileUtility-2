import Testing
@testable import FinderFileUtility_2

import Cocoa
import Combine
import Foundation
class NSPanelServiceTestCreateFileViewModel: ObservableObject, NSPanelManagementViewModelProtocol {
    
    static let viewType = NSPanelServiceTestCreateFileView.self
    var panelService: NSPanelServiceProtocol.Type? = nil
    deinit { NSLog("TestClass deinit") }

    weak var panel: NSPanel?
    static let title = "新規ファイル作成"
}
