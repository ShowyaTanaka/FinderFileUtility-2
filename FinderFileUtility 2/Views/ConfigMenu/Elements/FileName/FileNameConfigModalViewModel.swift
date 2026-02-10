import Combine
import Foundation
import SwiftUI

class FileNameConfigModalViewModel: ObservableObject, NSPanelControllerViewModelProtocol {
    var windowController: NSPanelController?

    weak var parentViewModel: FileNameConfigViewModel?
    let fileNameService: FileNameServiceProtocol
    @Published var fileName: String
    static let title = "新規ファイル名の変更"
    init(parentViewModel: FileNameConfigViewModel, fileNameService: FileNameServiceProtocol = fileNameServiceFactory()) {
        self.parentViewModel = parentViewModel
        self.fileName = parentViewModel.fileNameForDisplay
        self.fileNameService = fileNameService
    }
    func updateDefaultFileNameData() -> Bool {
        guard let parentVM = self.parentViewModel else { return false }
        self.fileNameService.writeDefaultFileNameData(newFileName: self.fileName)
        parentVM.refreshFileNameForDisplay()
        return true
    }
}
