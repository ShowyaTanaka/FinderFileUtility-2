struct FileExtensionService: FileExtensionServiceProtocol {
    let userDefaultsModel: UserDefaultsModelProtocol
    func getRegisteredExtension() -> [String] {
        if let registeredArray = self.userDefaultsModel.getArrayValue(forKey: UserDefaultsKey.fileExtensionKey) as? [String] {
            return registeredArray
        } else {
            // UserDefaultsに何も登録されていない場合は,空を返す
            _ = self.userDefaultsModel.setValue(value: [], forKey: UserDefaultsKey.fileExtensionKey)
            return []
        }
    }
    func setRegisteredExtension(_ newArray: [String]) -> Bool {
        return self.userDefaultsModel.setValue(value: newArray, forKey: UserDefaultsKey.fileExtensionKey)
    }
}
