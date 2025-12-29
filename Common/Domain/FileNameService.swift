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
        let defaultFileName = self.userDefaultsModel.getStringValue(forKey: "defaultFileName") ?? "新規ファイル"
        // 初回起動時等でUserDefaultsに値がセットされていない場合は、既定値をセットして返す。
        // このとき、すでに値が設定されている場合も保存処理が走るが、特段書き換えられるわけではないため影響はない。

        self.writeDefaultFileNameData(newFileName: defaultFileName)
        return defaultFileName
    }
    func renameFileName(fileName: String, index: Int) -> String {
        if fileName.contains(/[.]/) && !fileName.starts(with: ".") {
            let fileNameList = fileName.split(separator: ".")
            return "\(fileNameList.dropLast().joined(separator: ""))のコピー\(index).\(fileNameList.last!)"
        } else {
            // その他の場合は,末尾に「のコピーn」とつける
            return "\(fileName)のコピー\(index)"
        }
    }
}
