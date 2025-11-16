//
//  EditFileNameViewSet.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/09/21.
//
import Foundation
class CreateFileViewModel: ObservableObject {
    var currentDirURL: URL?
    @Published var fileName: String
    init(currentDirURL: URL, selectedExtension: String) {
        self.currentDirURL = currentDirURL

        self.fileName = FileNameService.getDefaultFileNameData()
        self.fileName += selectedExtension.starts(with: ".") ? selectedExtension : "." + selectedExtension
    }
    func createFile() -> Bool {
        guard let currentDirURLConfirm = self.currentDirURL else {return false}
        return FileManagementService.createFile(fileName: self.fileName, currentDirURL: currentDirURLConfirm)
    }
    func getFocusFileTextLength() -> Int {
        if self.fileName.contains(/[.]/) && !self.fileName.starts(with: "."){
            let fileNameList = self.fileName.split(separator: ".")
            return fileNameList.dropLast().joined(separator: "").count
        }
        return self.fileName.count
    }
}
