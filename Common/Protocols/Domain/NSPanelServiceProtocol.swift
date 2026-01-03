import Cocoa

import SwiftUI

protocol NSPanelServiceProtocol{
    static func createPanel<ContentVM: NSPanelManagementViewModelProtocol, V: View>(view: V,viewModel: ContentVM, isfocused: Bool, x: Int, y: Int, width: Int, height: Int)
}
