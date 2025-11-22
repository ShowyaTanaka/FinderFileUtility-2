import Foundation
import SwiftUI
import Combine

class EditFileExtensionModalViewModel:ObservableObject, NSPanelManagementViewModelProtocol {
    
    @Published var fileExtension:String = ""
    var errorDescription:String? = nil
    @Published var saveComplete: Bool = false
    var parentViewModel: EditFileExtensionViewModel
    @Published var isWindowClose = false
    var isWindowClosePublisher: AnyPublisher<Bool, Never> {
        return $isWindowClose.eraseToAnyPublisher()
    }
    
    private enum EditFileExtensionSaveStatus {
        case success
        case alreadyExists
        case unavailableName
        case unknownError
    }
    
    init(editFileExtensionViewModel: EditFileExtensionViewModel) {
        self.parentViewModel = editFileExtensionViewModel
    }
    
    private func appendRegisteredExtension(_ newElement: String) -> EditFileExtensionSaveStatus {
        guard newElement != "" else {return .unavailableName}
        var extensionArray = FileExtensionService.getRegisteredExtension()
        guard !extensionArray.contains(newElement) else {return .alreadyExists}
        extensionArray.append(newElement)
        let saveStatus = FileExtensionService.setRegisteredExtension(extensionArray)
        return saveStatus ? .success : .unknownError
    }

    func save() -> Bool{
        let fileSaveStatus = self.appendRegisteredExtension(self.fileExtension)
        switch fileSaveStatus {
        case .success:
            self.errorDescription = nil
            self.parentViewModel.refreshExtension()
            return true
        case .unknownError:
            self.errorDescription = "予期せぬエラーが発生しました"
        case .alreadyExists:
            self.errorDescription = "すでに登録されています"
        case .unavailableName:
            self.errorDescription = "使用できない拡張子名です"
    }
        let alert = NSAlert()
        alert.messageText = "拡張子の保存に失敗しました"
        alert.informativeText = self.errorDescription ?? "予期せぬエラーが発生しました"
        alert.addButton(withTitle: "OK")
        _ = alert.runModal()
        return false
    }
    
}
