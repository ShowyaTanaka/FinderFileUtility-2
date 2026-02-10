@testable import FFU2_Daemon
import Testing

@Suite
struct TestCreateFileViewModel {
    @Test("Windowが閉じた際に,ViewModelが正しく解放されることを確認するテスト")
    func testDeinit() async throws {
        NSPanelController()
    }

}
