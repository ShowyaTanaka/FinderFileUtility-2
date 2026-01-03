import Foundation
import SwiftUI

class FileNameConfigViewModel: ObservableObject {
    @Published var fileNameForDisplay: String = ""
    lazy var modalViewModel = FileNameConfigModalViewModel(parentViewModel: self)
    let fileNameService: FileNameServiceProtocol

    init(fileNameService: FileNameServiceProtocol = FileNameService(userDefaultsModel: UserDefaultsModel())) {
        let current_default_name_data: String = fileNameService.getDefaultFileNameData()
        self.fileNameForDisplay = current_default_name_data
        self.fileNameService = fileNameService
    }
    @MainActor
    func openFileNameConfigModal() {
        let viewModel = FileNameConfigModalViewModel(parentViewModel: self)
        let view = FileNameConfigModalView(viewModel: viewModel)
        NSPanelService.createPanel(view: view, viewModel: viewModel, isfocused: true, width: 300, height: 400)
    }
    func refreshFileNameForDisplay() {
        self.fileNameForDisplay = self.fileNameService.getDefaultFileNameData()
    }

}
