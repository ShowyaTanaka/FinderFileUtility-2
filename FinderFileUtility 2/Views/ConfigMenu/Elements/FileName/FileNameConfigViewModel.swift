import Foundation
import SwiftUI

class FileNameConfigViewModel: ObservableObject {
    @Published var fileNameForDisplay: String = ""
    lazy var modalViewModel = FileNameConfigModalViewModel(parentViewModel: self)

    init() {
        let current_default_name_data: String = FileNameService.getDefaultFileNameData()
        self.fileNameForDisplay = current_default_name_data
    }
    @MainActor
    func openFileNameConfigModal() {
        NSPanelService.createPanel(viewModel: self.modalViewModel, isfocused: true, width: 300, height: 400)
    }
    func refreshFileNameForDisplay() {
        self.fileNameForDisplay = FileNameService.getDefaultFileNameData()
    }

}
