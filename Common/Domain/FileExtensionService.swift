//
//  FileExtensionService.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/11/09.
//


struct FileExtensionService {
    static func getRegisteredExtension() -> [String] {
        if let registeredArray = UserDefaultsModel.getArrayValue(forKey: UserDefaultsKey.fileExtensionKey) as? [String] {
            return registeredArray
        }
        else {
            // UserDefaultsに何も登録されていない場合は,空を返す
            UserDefaultsModel.setValue(value: [], forKey: UserDefaultsKey.fileExtensionKey)
            return []
        }
    }
    static func setRegisteredExtension(_ newArray: [String]) -> Bool {
        return UserDefaultsModel.setValue(value: newArray, forKey: UserDefaultsKey.fileExtensionKey)
    }
}
