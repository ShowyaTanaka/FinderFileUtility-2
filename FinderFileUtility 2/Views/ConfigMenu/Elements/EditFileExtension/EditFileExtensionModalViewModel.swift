import Combine
import Foundation
import SwiftUI

class EditFileExtensionModalViewModel: ObservableObject, NSPanelControllerViewModelProtocol {
    var windowController: NSPanelController?

    @Published var fileExtension: String = ""
    var errorDescription: String?
    weak var parentViewModel: EditFileExtensionViewModel?
    static let title = "拡張子を追加"
    let fileExtensionService: FileExtensionServiceProtocol
    let nsAlertServiceType: NSAlertServiceProtocol.Type

    private enum EditFileExtensionSaveStatus {
        case success
        case alreadyExists
        case unavailableName
        case unknownError
    }

    init(editFileExtensionViewModel: EditFileExtensionViewModel, fileExtensionService: FileExtensionServiceProtocol, nsAlertService: NSAlertServiceProtocol.Type = NSAlertService.self) {
        self.parentViewModel = editFileExtensionViewModel
        self.fileExtensionService = fileExtensionService
        self.nsAlertServiceType = nsAlertService
    }

    private func appendRegisteredExtension(_ newElement: String) -> EditFileExtensionSaveStatus {
        guard newElement != "" else {return .unavailableName}
        var extensionArray = self.fileExtensionService.getRegisteredExtension()
        guard !extensionArray.contains(newElement) else {return .alreadyExists}
        extensionArray.append(newElement)
        let saveStatus = self.fileExtensionService.setRegisteredExtension(extensionArray)
        return saveStatus ? .success : .unknownError
    }

    func save() -> Bool {
        let fileSaveStatus = self.appendRegisteredExtension(self.fileExtension)
        switch fileSaveStatus {
        case .success:
            self.errorDescription = nil
            guard let parentVM = self.parentViewModel else {return false}
            parentVM.refreshExtension()
            return true
        case .unknownError:
            self.errorDescription = "予期せぬエラーが発生しました"
        case .alreadyExists:
            self.errorDescription = "すでに登録されています"
        case .unavailableName:
            self.errorDescription = "使用できない拡張子名です"
        }
        self.nsAlertServiceType.showAlert(title: "拡張子の保存に失敗しました", message: self.errorDescription ?? "予期せぬエラーが発生しました")
        return false
    }
    deinit {
        print("EditFileExtensionModalViewModel deinit")
    }

}
