import Cocoa
import Combine
import Foundation
class CreateFileViewModel: ObservableObject, NSPanelManagementViewModelProtocol {
    
    
    static let viewType = CreateFileView.self
    let fileManagementService: FileManagementServiceProtocol
    let panelService: NSPanelServiceProtocol.Type

    var closeRequested = PassthroughSubject<Void, Never>()
    var panel: NSPanel?
    var nsAlertService: NSAlertServiceProtocol.Type
    static let title = "新規ファイル作成"

    var currentDirURL: URL?
    @Published var fileName: String
    init(currentDirURL: URL, selectedExtension: String, fileNameService: FileNameServiceProtocol, fileManagementService: FileManagementServiceProtocol, panelService: NSPanelServiceProtocol.Type, nsAlertService: NSAlertServiceProtocol.Type = NSAlertService.self) {
        self.currentDirURL = currentDirURL
        self.fileManagementService = fileManagementService
        self.panelService = panelService
        self.nsAlertService = nsAlertService
        self.fileName = fileNameService.getDefaultFileNameData()
        self.fileName += selectedExtension.starts(with: ".") ? selectedExtension : "." + selectedExtension

    }
    func createFile() throws{
        guard let currentDirURLConfirm = self.currentDirURL else {return}
        try self.fileManagementService.createFile(fileName: self.fileName, currentDirURL: currentDirURLConfirm)
    }
    func getFocusFileTextLength() -> Int {
        if self.fileName.contains(/[.]/) && !self.fileName.starts(with: ".") {
            let fileNameList = self.fileName.split(separator: ".")
            return fileNameList.dropLast().joined(separator: "").count
        }
        return self.fileName.count
    }
}
