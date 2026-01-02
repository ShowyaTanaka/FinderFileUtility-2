import Testing
@testable import FinderFileUtility_2

@Suite
@MainActor
struct FileNameServiceTests {
    static func setUp() -> (FileNameService, MockUserDefaultsModel){
        let userDefaultsModel = MockUserDefaultsModel()
        let fileNameService = FileNameService(userDefaultsModel: userDefaultsModel)
        return (fileNameService, userDefaultsModel)
    }
    @Test("正しい文字列が与えられた場合,writeDefaultFileNameDataはその値をUserDefaultsに書き込む")
    func writeDefaultFileNameData_givenCorrectString_thenWriteToUserDefaults() {
        let (fileNameService, userDefaultsModel) = FileNameServiceTests.setUp()
        #expect(userDefaultsModel.mockDefaults["defaultFileName"] as? String == nil)
        fileNameService.writeDefaultFileNameData(newFileName: "Test new file")
        #expect(userDefaultsModel.mockDefaults["defaultFileName"] as? String == "Test new file")
    }
    
    @Test("空白文字列が与えられた場合,writeDefaultFileNameDataはその値をUserDefaultsに書き込む")
    func writeDefaultFileNameData_givenWhiteSpaceString_thenWriteToUserDefaults() {
        let (fileNameService, userDefaultsModel) = FileNameServiceTests.setUp()
        #expect(userDefaultsModel.mockDefaults["defaultFileName"] as? String == nil)
        fileNameService.writeDefaultFileNameData(newFileName: "")
        #expect(userDefaultsModel.mockDefaults["defaultFileName"] as? String == "")
    }
    @Test("UserDefaultsに値がセットされていない場合,getDefaultFileNameDataはUserDefaultsにデフォルト値を書き込み,その値を返す")
    func getDefaultFileNameData_givenNoValueInUserDefaults_thenWriteDefaultAndReturn() {
        let (fileNameService, userDefaultsModel) = FileNameServiceTests.setUp()
        #expect(userDefaultsModel.mockDefaults["defaultFileName"] as? String == nil)
        let result = fileNameService.getDefaultFileNameData()
        #expect(userDefaultsModel.mockDefaults["defaultFileName"] as? String == "New File")
        #expect(result == "New File")
    }
    @Test("UserDefaultsに空白値がセットされている場合,getDefaultFileNameDataはその値を返す")
    func getDefaultFileNameData_givenWhiteSpaceValueInUserDefaults_thenReturn() {
        let (fileNameService, userDefaultsModel) = FileNameServiceTests.setUp()
        userDefaultsModel.mockDefaults["defaultFileName"] = "" as String
        let result = fileNameService.getDefaultFileNameData()
        #expect(result == "")
        #expect(userDefaultsModel.mockDefaults["defaultFileName"] as? String == "")
    }
    @Test("UserDefaultsに通常の値がセットされている場合,getDefaultFileNameDataはその値を返す")
    func getDefaultFileNameData_givenNormalValueInUserDefaults_thenReturn() {
        let (fileNameService, userDefaultsModel) = FileNameServiceTests.setUp()
        userDefaultsModel.mockDefaults["defaultFileName"] = "Test file" as String
        let result = fileNameService.getDefaultFileNameData()
        #expect(result == "Test file")
        #expect(userDefaultsModel.mockDefaults["defaultFileName"] as? String == "Test file")
    }
    @Test("拡張子がついているファイル名が与えられた場合,renameFileNameは〇〇のコピー数字.hogeという値を返す")
    func renameFileName_givenFileNameWithExtension_thenReturnRenamedFileName() {
        let (fileNameService, _) = FileNameServiceTests.setUp()
        let result = fileNameService.renameFileName(fileName: "Test.hoge", index: 1)
        #expect(result == "Testのコピー1.hoge")
    }
    @Test("拡張子がついていないファイル名が与えられた場合,renameFileNameは〇〇のコピー数字という値を返す")
    func renameFileName_givenFileNameWithOutExtension_thenReturnRenamedFileName() {
        let (fileNameService, _) = FileNameServiceTests.setUp()
        let result = fileNameService.renameFileName(fileName: "Test", index: 1)
        #expect(result == "Testのコピー1")
    }
    @Test("名前にドットがついた拡張子付きのファイルを渡された場合,,renameFileNameは〇〇.〇〇のコピー数字という値を返す")
    func renameFileName_givenFileNameWithDotWithExtension_thenReturnRenamedFileName() {
        let (fileNameService, _) = FileNameServiceTests.setUp()
        let result = fileNameService.renameFileName(fileName: "Test.hoge.fuga", index: 1)
        #expect(result == "Test.hogeのコピー1.fuga")
    }
    @Test("最後にドットがついた拡張子付きのファイルを渡された場合,renameFileNameは〇〇.のコピー数字という値を返す")
    func renameFileName_givenFileNameWithDotOnlyWithExtension_thenReturnRenamedFileName() {
        let (fileNameService, _) = FileNameServiceTests.setUp()
        let result = fileNameService.renameFileName(fileName: "hoge.", index: 1)
        #expect(result == "hoge.のコピー1")
    }
    @Test("最初にドットがついた拡張子付きのファイルを渡された場合,renameFileNameは.〇〇のコピー数字という値を返す")
    func renameFileName_givenDotOnlyFileNameWithExtension_thenReturnRenamedFileName() {
        let (fileNameService, _) = FileNameServiceTests.setUp()
        let result = fileNameService.renameFileName(fileName: ".hoge", index: 1)
        #expect(result == ".hogeのコピー1")
    }
    
}
