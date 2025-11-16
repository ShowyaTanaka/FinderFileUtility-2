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
        let fileManager = FileManager.default
        let mergedFileUrl = directoryUrl.appendingPathComponent(fileName)
       // print("validate:\(mergedFileUrl.path.removingPercentEncoding!)")
        return !fileManager.fileExists(atPath: mergedFileUrl.path.removingPercentEncoding!)
    }
    
    private static func renameFileName(fileName: String, index: Int) -> String {
        if fileName.contains(/[.]/) && !fileName.starts(with: "."){
            let fileNameList = fileName.split(separator: ".")
            return "\(fileNameList.dropLast().joined(separator: ""))のコピー\(index).\(fileNameList.last!)"
        }
        else{
            print("else")
            // その他の場合は,末尾に「のコピーn」とつける
            return "\(fileName)のコピー\(index)"
        }
    }
    
    static func createFile(fileName: String, currentDirURL: URL) -> Bool {
        guard let securityScopedURL = SecureBookMarkModel.getSecureBookMarkUrl() else {return false}
        if !securityScopedURL.startAccessingSecurityScopedResource(){
            return false
        }
        var saveFileName = fileName
        defer {securityScopedURL.stopAccessingSecurityScopedResource()}
        if !self.validateDuplicateFileName(fileName: saveFileName, directoryUrl: currentDirURL) {
            // 重複している場合は,リネームして保存する
            var file_idx = 1
            saveFileName = FileManagementService.renameFileName(fileName: fileName, index: 1)
            while !self.validateDuplicateFileName(fileName: saveFileName, directoryUrl: currentDirURL) {
                file_idx += 1
                saveFileName = FileManagementService.renameFileName(fileName: fileName, index: file_idx)
            }
        }
        let mergedDirectoryURL = currentDirURL.appendingPathComponent(saveFileName)
        guard let savePath = mergedDirectoryURL.path().removingPercentEncoding else {return false}
        print("saveDir:\(savePath)")
        FileManager.default.createFile(atPath: savePath, contents: nil)
        return true
    }
    
}
