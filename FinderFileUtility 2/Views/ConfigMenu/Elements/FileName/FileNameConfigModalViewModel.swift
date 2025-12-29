import Combine
import Foundation
import SwiftUI

class FileNameConfigModalViewModel: ObservableObject, NSPanelManagementViewModelProtocol {
    var panel: NSPanel?
    weak var parentViewModel: FileNameConfigViewModel?
    static let viewType = FileNameConfigModalView.self
    let fileNameService: FileNameServiceProtocol
    @Published var fileName: String
    let panelService: NSPanelServiceProtocol.Type
    static let title = "新規ファイル名の変更"
    init(parentViewModel: FileNameConfigViewModel, fileNameService: FileNameServiceProtocol = fileNameServiceFactory(), panelServiceType: NSPanelServiceProtocol.Type = NSPanelService.self) {
        self.parentViewModel = parentViewModel
        self.fileName = parentViewModel.fileNameForDisplay
        self.fileNameService = fileNameService
        self.panelService = panelServiceType
    }
    func updateDefaultFileNameData() {
        guard let parentVM = self.parentViewModel else { return }
        self.fileNameService.writeDefaultFileNameData(newFileName: self.fileName)
        parentVM.refreshFileNameForDisplay()
        self.closeWindow()
    }
}
