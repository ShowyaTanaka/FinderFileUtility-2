import Testing
@testable import FinderFileUtility_2

@Suite
@MainActor
struct FileExtensionServiceTests {
    static func setUp() -> (MockUserDefaultsModel, FileExtensionService) {
        let mockDefaultsModel = MockUserDefaultsModel()
        let FileExtensionService = FileExtensionService(userDefaultsModel: mockDefaultsModel)
        return(mockDefaultsModel, FileExtensionService)
    }
    
    @Test("UserDefaultsに初期値が入っていない場合,getRegisteredExtensionは正しく初期値を登録したうえで,値を返却すること。")
    func getRegisteredExtension_noInitialValue_thenSetAndReturnInitialValue(){
        let (mockDefaultsModel, fileExtensionService) = FileExtensionServiceTests.setUp()
        let getExtensionValue = fileExtensionService.getRegisteredExtension()
        #expect(mockDefaultsModel.mockDefaults[UserDefaultsKey.fileExtensionKey] as? [String] == [])
        #expect(getExtensionValue == [])
    }
    @Test("UserDefaultsにすでに値が入っている場合,getRegisteredExtensionはその値を返すこと。")
    func getRegisteredExtension_hasInitialValue_thenReturnThatValue(){
        let (mockDefaultsModel, fileExtensionService) = FileExtensionServiceTests.setUp()
        mockDefaultsModel.mockDefaults[UserDefaultsKey.fileExtensionKey] = ["txt", "jpg"]
        let getExtensionValue = fileExtensionService.getRegisteredExtension()
        #expect(mockDefaultsModel.mockDefaults[UserDefaultsKey.fileExtensionKey] as? [String] == ["txt", "jpg"])
        #expect(getExtensionValue == ["txt", "jpg"])
    }
    @Test("値が登録されていない場合,setRegisteredExtensionで新しく値を登録できること。")
    func setRegisteredExtension_noValue_thenSetNewValue(){
        let (mockDefaultsModel, fileExtensionService) = FileExtensionServiceTests.setUp()
        _ = fileExtensionService.getRegisteredExtension()
        #expect(mockDefaultsModel.mockDefaults[UserDefaultsKey.fileExtensionKey] as? [String] == [])
        _ = fileExtensionService.setRegisteredExtension(["txt"])
        #expect(mockDefaultsModel.mockDefaults[UserDefaultsKey.fileExtensionKey] as? [String] == ["txt"])
    }
    @Test("既に値が登録されている場合であっても,setRegisteredExtensionで値を上書きできること。")
    func setRegisteredExtension_hasValue_thenOverwriteValue(){
        let (mockDefaultsModel, fileExtensionService) = FileExtensionServiceTests.setUp()
        mockDefaultsModel.mockDefaults[UserDefaultsKey.fileExtensionKey] = ["txt"]
        _ = fileExtensionService.getRegisteredExtension()
        #expect(mockDefaultsModel.mockDefaults[UserDefaultsKey.fileExtensionKey] as? [String] == ["txt"])
        _ = fileExtensionService.setRegisteredExtension(["jpg"])
        #expect(mockDefaultsModel.mockDefaults[UserDefaultsKey.fileExtensionKey] as? [String] == ["jpg"])
    }
    
}
