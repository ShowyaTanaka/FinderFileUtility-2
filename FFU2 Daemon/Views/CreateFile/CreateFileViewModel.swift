import Cocoa
import Combine
import Foundation
class CreateFileViewModel: ObservableObject, NSPanelControllerViewModelProtocol {
    var windowController: NSPanelController?
    
    
    
    static let viewType = CreateFileView.self
    let fileManagementService: FileManagementServiceProtocol

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
    func createFile() -> Bool{
        guard let currentDirURLConfirm = self.currentDirURL else {return true}
        do {
            try self.fileManagementService.createFile(fileName: self.fileName, currentDirURL: currentDirURLConfirm)
            return true
        }
        catch {
            self.nsAlertService.showAlert(title: "エラー", message: "ファイルの作成に失敗しました。\(error)")
            return false
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
