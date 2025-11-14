//
//  FileExtensionService.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/11/09.
//

struct FileExtensionService {
    private static let fileExtensionKey = "FileExtensions"
    static func getRegisteredExtension() -> [String] {
        if let registeredArray = UserDefaultsModel.getArrayValue(forKey: fileExtensionKey) as? [String] {
            return registeredArray
        }
        else {
            // UserDefaultsに何も登録されていない場合は,空を返す
            UserDefaultsModel.setValue(value: [], forKey: fileExtensionKey)
            return []
        }
    }
    static func setRegisteredExtension(_ newArray: [String]) -> Bool {
        return UserDefaultsModel.setValue(value: newArray, forKey: fileExtensionKey)
    }
    static func appendRegisteredExtension(_ newElement: String) -> EditFileExtensionSaveStatus {
        guard newElement != "" else {return .unavailableName}
        var extensionArray = FileExtensionService.getRegisteredExtension()
        guard !extensionArray.contains(newElement) else {return .alreadyExists}
        extensionArray.append(newElement)
        let saveStatus = FileExtensionService.setRegisteredExtension(extensionArray)
        return saveStatus ? .success : .unknownError
    }
}
