import SwiftUI
protocol NSPanelManagementView: View {
    associatedtype isCloseWindowStat: isCloseWindowStatus
    var isCloseWindow: isCloseWindowStat { get }
}
extension NSPanelManagementView {
    func closeWindow() {
        self.isCloseWindow.isClose = true
    }
}

class isCloseWindowStatus: ObservableObject {
    @Published var isClose: Bool = false
}
