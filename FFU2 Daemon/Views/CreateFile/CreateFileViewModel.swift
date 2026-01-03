import Cocoa
import Combine
import Foundation
class CreateFileViewModel: ObservableObject, NSPanelManagementViewModelProtocol {
    
    
    static let viewType = CreateFileView.self
    let fileManagementService: FileManagementServiceProtocol
    var panelService: NSPanelServiceProtocol.Type?

    var closeRequested = PassthroughSubject<Void, Never>()
    var panel: NSPanel?
    var nsAlertService: NSAlertServiceProtocol.Type
    static let title = "新規ファイル作成"

    var currentDirURL: URL?
    @Published var fileName: String
    init(currentDirURL: URL, selectedExtension: String, fileNameService: FileNameServiceProtocol, fileManagementService: FileManagementServiceProtocol, nsAlertService: NSAlertServiceProtocol.Type = NSAlertService.self) {
        self.currentDirURL = currentDirURL
        self.fileManagementService = fileManagementService
        self.nsAlertService = nsAlertService
        self.fileName = fileNameService.getDefaultFileNameData()
        self.fileName += selectedExtension.starts(with: ".") ? selectedExtension : "." + selectedExtension
    }
    @MainActor
    func createFile(){
        guard let currentDirURLConfirm = self.currentDirURL else {return}
        do {
            try self.fileManagementService.createFile(fileName: self.fileName, currentDirURL: currentDirURLConfirm)
            self.closeWindow()
        }
        catch {
            self.nsAlertService.showAlert(title: "エラー", message: "ファイルの作成に失敗しました。\(error)")
        }
    }
    func getFocusFileTextLength() -> Int {
        if self.fileName.contains(/[.]/) && !self.fileName.starts(with: ".") {
            let fileNameList = self.fileName.split(separator: ".")
            return fileNameList.dropLast().joined(separator: "").count
        }
        return self.fileName.count
    }
}
