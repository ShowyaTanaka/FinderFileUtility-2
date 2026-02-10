import Cocoa
import Foundation
struct ExtensionName: Identifiable {
    var id = UUID()
    var extensionName: String
}
class EditFileExtensionViewModel: ObservableObject {
    @Published var extensions: [ExtensionName]
    let fileExtensionService: FileExtensionServiceProtocol
    let nsPanelControllerType: NSPanelController.Type
    lazy var modalViewModel = EditFileExtensionModalViewModel(editFileExtensionViewModel: self, fileExtensionService: self.fileExtensionService)
    init(fileExtensionService: FileExtensionServiceProtocol = fileExtensionServiceFactory(), nsPanelControllerType: NSPanelController.Type = NSPanelController.self) {
        let extensionArray = fileExtensionService.getRegisteredExtension()
        self.fileExtensionService = fileExtensionService
        self.extensions = []
        self.nsPanelControllerType = nsPanelControllerType

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
        _ = self.fileExtensionService.setRegisteredExtension(extensionNameArray)
        self.refreshExtension()
    }
    func refreshExtension() {
        let extensionArray = self.fileExtensionService.getRegisteredExtension()
        var extensionNames: [ExtensionName] = []
        for extensionName in extensionArray {
            extensionNames.append(ExtensionName(extensionName: extensionName))
        }
        self.extensions = extensionNames
    }
    @MainActor
    func openEditFileModal() {
        let viewModel = EditFileExtensionModalViewModel(editFileExtensionViewModel: self, fileExtensionService: self.fileExtensionService)
        let view = EditFileExtensionModalView(viewModel: viewModel)
        self.nsPanelControllerType.init(viewModel: viewModel, view: view, isfocused: false, x: 600, y: 400, width: 300, height: 200)
    }

}
