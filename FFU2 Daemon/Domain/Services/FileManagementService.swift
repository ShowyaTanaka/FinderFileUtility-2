import Foundation
struct FileManagementService: FileManagementServiceProtocol {

    var fileRepository: FileIRepository
    let fileNameService: FileNameServiceProtocol
    
    init(fileNameService: FileNameServiceProtocol) {
        self.fileRepository = FileRepository(secureBookMarkService: SecureBookMarkService(userDefaultsModel: UserDefaultsModel()))
        self.fileNameService = fileNameService
    }
    private func validateDuplicateFileName(fileName: String, directoryUrl: URL) throws -> Bool {
        /*
         ファイル名の重複確認をする関数。重複するファイルが存在する場合にはfalseを返し,重複するファイルが存在しない場合にはtrueを返す。
         */
        let mergedFileUrl = directoryUrl.appendingPathComponent(fileName)
        return try !self.fileRepository.exists(path: mergedFileUrl)

    }
    
    private func renameFileName(fileName: String, currentDirURL: URL) throws -> String {
        var file_idx = 1
        var saveFileName = self.fileNameService.renameFileName(fileName: fileName, index: 1)
        var duplicateFileResult = try self.validateDuplicateFileName(fileName: saveFileName, directoryUrl: currentDirURL)
        while !duplicateFileResult {
            file_idx += 1
            saveFileName = self.fileNameService.renameFileName(fileName: fileName, index: file_idx)
            let tempDuplicateFileResult = try self.validateDuplicateFileName(fileName: saveFileName, directoryUrl: currentDirURL)
            duplicateFileResult = tempDuplicateFileResult
        }
        return saveFileName
    }

    func createFile(fileName: String, currentDirURL: URL) throws {
        var saveFileName = fileName
        let duplicateFileResult = try self.validateDuplicateFileName(fileName: saveFileName, directoryUrl: currentDirURL)
        if !duplicateFileResult {
            // 重複している場合は,リネームして保存する
            saveFileName = try self.renameFileName(fileName: fileName, currentDirURL: currentDirURL)
        }
        let mergedDirectoryURL = currentDirURL.appendingPathComponent(saveFileName)
        _ = try self.fileRepository.create(path: mergedDirectoryURL, data: nil)
 
    }

}
