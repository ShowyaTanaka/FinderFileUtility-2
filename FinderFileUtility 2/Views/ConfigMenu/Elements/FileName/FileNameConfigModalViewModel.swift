import Combine
import Foundation
import SwiftUI

class FileNameConfigModalViewModel: ObservableObject, NSPanelManagementViewModelProtocol {
    var panel: NSPanel?
    weak var parentViewModel: FileNameConfigViewModel?
    static let viewType = FileNameConfigModalView.self
    @Published var fileName: String
    static let title = "新規ファイル名の変更"
    init(parentViewModel: FileNameConfigViewModel) {
        self.parentViewModel = parentViewModel
        self.fileName = parentViewModel.fileNameForDisplay
    }
    func updateDefaultFileNameData() {
        guard let parentVM = self.parentViewModel else { return }
        FileNameService.writeDefaultFileNameData(newFileName: self.fileName)
        parentVM.refreshFileNameForDisplay()
        self.closeWindow()
    }
}
