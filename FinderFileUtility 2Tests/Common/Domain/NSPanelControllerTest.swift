@testable import FinderFileUtility_2
import Foundation
import Testing

@Suite
@MainActor
struct NSPanelServiceTest {
    @Test("NSPanelControllerViewModelからcloseWindowが呼ばれた際に,適切にNSPanelがdeinitされること。")
    func testDeinit() async {
        var viewModel: NSPanelServiceTestCreateFileViewModel? = NSPanelServiceTestCreateFileViewModel()
        var view: NSPanelServiceTestCreateFileView? = NSPanelServiceTestCreateFileView(viewModel: viewModel!)
        weak var weakViewModel = viewModel

        weak let controller = NSPanelController(
            viewModel: viewModel!, view: view!,
            isfocused: false, x: 0, y: 0, width: 0, height: 0)
        view = nil
        viewModel = nil
        #expect(weakViewModel?.windowController?.window != nil)
        weakViewModel!.closeWindow()
        #expect(weakViewModel?.windowController?.window == nil)
    }
}
