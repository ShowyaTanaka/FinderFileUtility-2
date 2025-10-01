//
//  EditFileNameModel.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/09/21.
//
import Foundation
struct FileManagementService {
    
    private static func validateDuplicateFileName(fileName: String, directoryUrl: URL) -> Bool {
        /*
         ファイル名の重複確認をする関数。重複するファイルが存在する場合にはfalseを返し,重複するファイルが存在しない場合にはtrueを返す。
         */
        let directoryURL = directoryUrl.deletingLastPathComponent()
        let fileManager = FileManager.default
        let mergedFileUrl = directoryURL.appendingPathComponent(fileName)
        return !fileManager.fileExists(atPath: mergedFileUrl.path)
    }
    
    static func createFile(fileName: String, currentDirURL: URL) -> Bool {
        guard let url = SecureBookMarkModel.getSecureBookMarkUrl() else {return false}
        if !url.startAccessingSecurityScopedResource(){
            return false
        }
        defer {url.stopAccessingSecurityScopedResource()}
        if self.validateDuplicateFileName(fileName: fileName, directoryUrl: currentDirURL) {
            let mergedDirectoryURL = url.deletingLastPathComponent().appendingPathComponent(fileName)
            FileManager.default.createFile(atPath: mergedDirectoryURL.path(), contents: nil)
            return true
        }
        else {
            // 重複している場合は,リネームして保存する
            var file_idx = 1
            var mergedFileName = FileManagementService.renameFileName(fileName: fileName, index: 1)
            while !self.validateDuplicateFileName(fileName: mergedFileName, directoryUrl: url) {
                file_idx += 1
                mergedFileName = FileManagementService.renameFileName(fileName: fileName, index: file_idx)
            }
            let mergedDirectoryURL = url.deletingLastPathComponent().appendingPathComponent(fileName)
            FileManager.default.createFile(atPath: mergedDirectoryURL.path(), contents: nil)
            return true
        }
    }
    
    static func getNewFileName(ext: String, currentDirURL: URL) -> String {
        // 新規作成する際のファイル名候補を作成する関数。
        // ファイル名取得では
        let originFileName = FileNameConfigService.getDefaultFileNameData() + "." + ext
        var fileName = originFileName
        var file_idx = 0
        while !self.validateDuplicateFileName(fileName: fileName, directoryUrl: currentDirURL) {
            file_idx += 1
            fileName = FileManagementService.renameFileName(fileName: originFileName, index: file_idx)
        }
        return fileName
    }
    
    static func renameFileName(fileName: String, index: Int) -> String {
        let normalPattern = /!\.+\.!\.+/
        if fileName.firstMatch(of: normalPattern) != nil {
            // hoge.txtのようなノーマル型の場合は, hogeのコピー.txtのようにする
            let fileNameList = fileName.split(separator: ".")
            return "\(fileNameList.first!)のコピー\(index).\(fileNameList.last!)"
        }
        else{
            // その他の場合は,末尾に「のコピーn」とつける
            return "\(fileName)のコピー\(index)"
        }
    }
    
}
