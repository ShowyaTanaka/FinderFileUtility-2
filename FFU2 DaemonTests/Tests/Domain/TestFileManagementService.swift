@testable import FFU2_Daemon
import Foundation
import Testing

struct TestFileManagementService {
    @Test("重複するファイルが存在しない場合、指定された名前でファイルが保存されること。")
    func testSaveFile_NoDuplicate() {
        let mockFileRepository = TestFileManagementServiceFileRepository()
        let fileManagementService = FileManagementService(fileNameService: FileNameService(userDefaultsModel: TestFileManagementServiceMockUserDefaultsModel()), fileRepository: mockFileRepository)
        try! fileManagementService.createFile(fileName: "TestFile.txt", currentDirURL: URL(fileURLWithPath: "/TestDirectory"))
        let createdFileName = mockFileRepository.createdFileName
        #expect(createdFileName == "TestFile.txt")
    }
    @Test("重複するファイルが1つ存在する場合、指定された名前をリネームしてファイルが保存されること。")
    func testSaveFile_Duplicate_1() {
        let mockFileRepository = TestFileManagementServiceFileRepository()
        mockFileRepository.existCount = 1
        let fileManagementService = FileManagementService(fileNameService: FileNameService(userDefaultsModel: TestFileManagementServiceMockUserDefaultsModel()), fileRepository: mockFileRepository)
        try! fileManagementService.createFile(fileName: "TestFile.txt", currentDirURL: URL(fileURLWithPath: "/TestDirectory"))
        let createdFileName = mockFileRepository.createdFileName
        #expect(createdFileName == "TestFileのコピー1.txt")
    }
    @Test("重複するファイルが2つ以上存在する場合、指定された名前をリネームしてファイルが保存されること。")
    func testSaveFile_Duplicate_over_2() {
        let mockFileRepository = TestFileManagementServiceFileRepository()
        mockFileRepository.existCount = 2
        let fileManagementService = FileManagementService(fileNameService: FileNameService(userDefaultsModel: TestFileManagementServiceMockUserDefaultsModel()), fileRepository: mockFileRepository)
        try! fileManagementService.createFile(fileName: "TestFile.txt", currentDirURL: URL(fileURLWithPath: "/TestDirectory"))
        let createdFileName = mockFileRepository.createdFileName
        #expect(createdFileName == "TestFileのコピー2.txt")
    }
}
