import Foundation
import SwiftUI

class FileNameConfigViewModel: ObservableObject {
    @Published var fileNameForDisplay: String = ""
    lazy var modalViewModel = FileNameConfigModalViewModel(parentViewModel: self)
    let fileNameService: FileNameServiceProtocol
    let nsPanelControllerType: NSPanelController.Type

    init(fileNameService: FileNameServiceProtocol = FileNameService(userDefaultsModel: UserDefaultsModel()), nsPanelControllerType: NSPanelController.Type = NSPanelController.self) {
        let current_default_name_data: String = fileNameService.getDefaultFileNameData()
        self.fileNameForDisplay = current_default_name_data
        self.fileNameService = fileNameService
        self.nsPanelControllerType = nsPanelControllerType
    }
    @MainActor
    func openFileNameConfigModal() {
        let viewModel = FileNameConfigModalViewModel(parentViewModel: self)
        let view = FileNameConfigModalView(viewModel: viewModel)
        self.nsPanelControllerType.init(viewModel: viewModel, view: view, isfocused: true, x: 600, y: 400, width: 300, height: 400)
    }
    func refreshFileNameForDisplay() {
        self.fileNameForDisplay = self.fileNameService.getDefaultFileNameData()
    }

}
