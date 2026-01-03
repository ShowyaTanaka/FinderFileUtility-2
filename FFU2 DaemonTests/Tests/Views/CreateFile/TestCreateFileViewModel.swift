import Testing
@testable import FFU2_Daemon

@Suite
struct TestCreateFileViewModel {
    @Test("Windowが閉じた際に,ViewModelが正しく解放されることを確認するテスト")
    func testDeinit() async throws {
        let nsPanelService = NSPanelService.self
    }
            
}
