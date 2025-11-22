import Foundation
struct FileManagementService {
    
    var fileRepository: FileIRepository
    init() {
        self.fileRepository = FileRepository()
    }
    private func validateDuplicateFileName(fileName: String, directoryUrl: URL) -> Bool? {
        /*
         ファイル名の重複確認をする関数。重複するファイルが存在する場合にはfalseを返し,重複するファイルが存在しない場合にはtrueを返す。
         */
        let mergedFileUrl = directoryUrl.appendingPathComponent(fileName)
        do{
            return try self.fileRepository.exists(path: mergedFileUrl)
        }
        catch{
            return nil
        }

    }
    
    func createFile(fileName: String, currentDirURL: URL) -> Bool {
        var saveFileName = fileName
        guard var duplicateFileResult = self.validateDuplicateFileName(fileName: saveFileName, directoryUrl: currentDirURL) else {return false}
        if !duplicateFileResult {
            // 重複している場合は,リネームして保存する
            var file_idx = 1
            saveFileName = FileNameService.renameFileName(fileName: fileName, index: 1)
            guard var duplicateFileResult = self.validateDuplicateFileName (fileName: saveFileName, directoryUrl: currentDirURL) else {return false}
            while !duplicateFileResult {
                file_idx += 1
                saveFileName = FileNameService.renameFileName(fileName: fileName, index: file_idx)
            }
        }
        let mergedDirectoryURL = currentDirURL.appendingPathComponent(saveFileName)
        do {
            return try self.fileRepository.create(path: mergedDirectoryURL, data: nil)
        }
        catch {
            return false
        }
    }
    
}
