//
//  EditFileExtensionViewModel.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/11/09.
//
import Foundation
struct ExtensionName: Identifiable {
    var id = UUID()
    var extensionName: String
}
class EditFileExtensionViewModel:ObservableObject {
    @Published var extensions: [ExtensionName]
    init() {
        let extensionArray = FileExtensionService.getRegisteredExtension()
        self.extensions = []
        for extensionName in extensionArray {
            self.extensions.append(ExtensionName(extensionName: extensionName))
        }
        // self.extensions = FileExtensionService.getRegisteredExtension()
    }
    
    func deleteExtension(extensionID: ExtensionName.ID) {
        print("DELETE")
        let targetDeletedExtensionName = self.extensions.filter{$0.id != extensionID}
        var extensionNameArray:[String] = []
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

}
