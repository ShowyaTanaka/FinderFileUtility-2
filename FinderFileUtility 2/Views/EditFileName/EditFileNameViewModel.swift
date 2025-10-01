//
//  EditFileNameViewSet.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/09/21.
//
import Foundation
class EditFileNameViewModel: ObservableObject {
    var currentDirURL: URL?
    var selectedExt: String?
    @Published var fileName: String
    init(currentDirURL: URL? = nil, selectedExt: String? = nil) {
        self.currentDirURL = currentDirURL
        self.selectedExt = selectedExt
        guard let currentDirURLConfirmed = currentDirURL, let selectedExtConfirmed = selectedExt else {
            // selectedExt,あるいはcurrentDirURLのどちらかがnilの場合は,拡張子なしのデフォルト名を取る。
            self.fileName = FileNameConfigService.getDefaultFileNameData()
            return
        }
        self.fileName = FileManagementService.getNewFileName(ext: selectedExtConfirmed, currentDirURL: currentDirURLConfirmed)
    }
    func createFile(fileName: String) -> Bool {
        guard let currentDirURLConfirm = self.currentDirURL else {return false}
        return FileManagementService.createFile(fileName: fileName, currentDirURL: currentDirURLConfirm )
    }
}
