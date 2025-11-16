//
//  FileNameService.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/11/14.
//

struct FileNameService {
    
    static func writeDefaultFileNameData(newFileName: String) {
        // 空白文字列は許容する。nilで渡されたプロパティは更新対象としない。
        _ = UserDefaultsModel.setValue(value: newFileName, forKey: "defaultFileName")
    }
    
    static func getDefaultFileNameData() -> String {
        let default_file_name = UserDefaultsModel.getStringValue(forKey: "defaultFileName") ?? "新規ファイル"
        // 初回起動時等でUserDefaultsに値がセットされていない場合は、既定値をセットして返す。
        //このとき、すでに値が設定されている場合も保存処理が走るが、特段書き換えられるわけではないため影響はない。
        
        FileNameService.writeDefaultFileNameData(newFileName: default_file_name)
        return default_file_name
    }
}
