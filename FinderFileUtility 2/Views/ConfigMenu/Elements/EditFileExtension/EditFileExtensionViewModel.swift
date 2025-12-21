import Cocoa
import Foundation
struct ExtensionName: Identifiable {
    var id = UUID()
    var extensionName: String
}
class EditFileExtensionViewModel: ObservableObject {
    @Published var extensions: [ExtensionName]
    lazy var modalViewModel = EditFileExtensionModalViewModel(editFileExtensionViewModel: self)
    init() {
        let extensionArray = FileExtensionService.getRegisteredExtension()
        self.extensions = []

        for extensionName in extensionArray {
            self.extensions.append(ExtensionName(extensionName: extensionName))
        }
    }

    func deleteExtension(extensionID: ExtensionName.ID) {
        let targetDeletedExtensionName = self.extensions.filter { $0.id != extensionID }
        var extensionNameArray: [String] = []
        for extensionName in targetDeletedExtensionName {
            extensionNameArray.append(extensionName.extensionName)
        }
        _ = FileExtensionService.setRegisteredExtension(extensionNameArray)
        self.refreshExtension()
    }
    func refreshExtension() {
        let extensionArray = FileExtensionService.getRegisteredExtension()
        var extensionNames: [ExtensionName] = []
        for extensionName in extensionArray {
            extensionNames.append(ExtensionName(extensionName: extensionName))
        }
        self.extensions = extensionNames
    }
    @MainActor
    func openEditFileModal() {
        NSPanelService.createPanel(viewModel: self.modalViewModel, isfocused: true, width: 300, height: 400)
    }

}
