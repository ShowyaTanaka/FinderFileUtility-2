import SwiftUI
import Combine
protocol NSPanelManagementView: View {
    associatedtype VM: NSPanelManagementViewModelProtocol
    var viewModel: VM {get}
}
protocol NSPanelManagementViewModelProtocol {
    var isWindowClosePublisher: AnyPublisher<Bool, Never> { get }
}

