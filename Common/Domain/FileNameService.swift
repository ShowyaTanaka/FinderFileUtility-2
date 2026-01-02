struct FileNameService: FileNameServiceProtocol {
    let userDefaultsModel: UserDefaultsModelProtocol
    
    init(userDefaultsModel: UserDefaultsModelProtocol) {
        self.userDefaultsModel = userDefaultsModel
    }

    func writeDefaultFileNameData(newFileName: String) {
        // 空白文字列は許容する。nilで渡されたプロパティは更新対象としない。
        _ = self.userDefaultsModel.setValue(value: newFileName, forKey: "defaultFileName")
    }

    func getDefaultFileNameData() -> String {
        let defaultFileName = self.userDefaultsModel.getStringValue(forKey: "defaultFileName") ?? "New File"
        // 初回起動時等でUserDefaultsに値がセットされていない場合は、既定値をセットして返す。
        // このとき、すでに値が設定されている場合も保存処理が走るが、特段書き換えられるわけではないため影響はない。

        self.writeDefaultFileNameData(newFileName: defaultFileName)
        return defaultFileName
    }
    func renameFileName(fileName: String, index: Int) -> String {
        guard
            fileName.last != ".",
            fileName.first != ".",
            let lastDotIndex = fileName.lastIndex(of: ".")
        else {
            // ドットが含まれていない、または末尾がドットの場合
            return "\(fileName)のコピー\(index)"
        }
        let fileNameBeforeExtension = fileName[..<lastDotIndex]
        let extensionPart = fileName[fileName.index(after: lastDotIndex)...]
        return "\(fileNameBeforeExtension)のコピー\(index).\(extensionPart)"
    }
}
