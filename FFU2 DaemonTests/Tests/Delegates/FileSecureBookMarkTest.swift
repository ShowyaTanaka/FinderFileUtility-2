internal import AppKit
@testable import FFU2_Daemon
import Foundation
import Testing

@Suite
@MainActor
struct FileSecureBookMarkTest {
    @Test("resultがキャンセルの場合、何もせずにreturnすること")
    func testSaveSecureBookMark_Cancel() async {
        FileSecureBookMarkTestMockNSAlertService.reset()
        let nsAlertService = FileSecureBookMarkTestMockNSAlertService.self
        let secureBookMarkService = FileSecureBookMarkTestMockSecureBookMarkService()
        let nsOpenPanelService = FileSecureBookMarkTestMockNSOpenPanelService()
        nsOpenPanelService.runModalResult = .cancel

        let fileSecureBookMark = FileSecureBookMark(
            nsAlertService: nsAlertService,
            secureBookMarkService: secureBookMarkService,
            nsOpenPanelService: nsOpenPanelService
        )

        await fileSecureBookMark.saveSecureBookMark()
        #expect(nsOpenPanelService.runModalCalledCount == 1)
        #expect(nsAlertService.showAlertCalledCount == 0)
        #expect(secureBookMarkService.saveSecureBookMarkCalledNum == 0)
    }
    @Test("resultがcancel,OK以外の場合、エラーアラートを表示すること")
    func testSaveSecureBookMark_Error() async {
        FileSecureBookMarkTestMockNSAlertService.reset()
        let nsAlertService = FileSecureBookMarkTestMockNSAlertService.self
        let secureBookMarkService = FileSecureBookMarkTestMockSecureBookMarkService()
        let nsOpenPanelService = FileSecureBookMarkTestMockNSOpenPanelService()
        nsOpenPanelService.runModalResult = .abort
        let fileSecureBookMark = FileSecureBookMark(
            nsAlertService: nsAlertService,
            secureBookMarkService: secureBookMarkService,
            nsOpenPanelService: nsOpenPanelService
        )

        await fileSecureBookMark.saveSecureBookMark()
        #expect(nsOpenPanelService.runModalCalledCount == 1)
        #expect(nsAlertService.showAlertCalledCount == 1)
        #expect(secureBookMarkService.saveSecureBookMarkCalledNum == 0)
        #expect(nsAlertService.shownAlerts[0].title == "エラー")
        #expect(nsAlertService.shownAlerts[0].message == "何らかのエラーが発生しました。再度実行してください。")
    }
    @Test("unsupportedDirectoryエラーが発生した場合、対応するアラートを表示すること")
    func testSaveSecureBookMark_UnsupportedDirectoryError() async {
        FileSecureBookMarkTestMockNSAlertService.reset()
        let nsAlertService = FileSecureBookMarkTestMockNSAlertService.self
        let secureBookMarkService = FileSecureBookMarkTestMockSecureBookMarkService()
        let nsOpenPanelService = FileSecureBookMarkTestMockNSOpenPanelService()
        nsOpenPanelService.runModalResult = .OK
        nsOpenPanelService.secureBookMarkUrlToReturn = URL(fileURLWithPath: "/invalid")
        let fileSecureBookMark = FileSecureBookMark(
            nsAlertService: nsAlertService,
            secureBookMarkService: secureBookMarkService,
            nsOpenPanelService: nsOpenPanelService
        )
        await fileSecureBookMark.saveSecureBookMark()
        #expect(nsOpenPanelService.runModalCalledCount == 1)
        #expect(nsAlertService.showAlertCalledCount == 1)
        #expect(secureBookMarkService.saveSecureBookMarkCalledNum == 0)
        #expect(nsAlertService.shownAlerts[0].title == "サポートされていないディレクトリ")
        #expect(nsAlertService.shownAlerts[0].message == "指定したディレクトリはサポートされていません。ホームディレクトリ、あるいはそれより下の階層を指定してください。")
    }
    @Test("正常に処理が完了する場合、アラートは表示されないこと")
    func testSaveSecureBookMark_Success() async {
        FileSecureBookMarkTestMockNSAlertService.reset()
        let nsAlertService = FileSecureBookMarkTestMockNSAlertService.self
        let secureBookMarkService = FileSecureBookMarkTestMockSecureBookMarkService()
        let nsOpenPanelService = FileSecureBookMarkTestMockNSOpenPanelService()
        nsOpenPanelService.runModalResult = .OK
        nsOpenPanelService.secureBookMarkUrlToReturn = URL(fileURLWithPath: nsOpenPanelService.getNSHomeDirectory())
        let fileSecureBookMark = FileSecureBookMark(
            nsAlertService: nsAlertService,
            secureBookMarkService: secureBookMarkService,
            nsOpenPanelService: nsOpenPanelService
        )
        await fileSecureBookMark.saveSecureBookMark()
        #expect(nsOpenPanelService.runModalCalledCount == 1)
        #expect(nsAlertService.showAlertCalledCount == 0)
        #expect(nsAlertService.showAlertWithUserSelectCalledCount == 0)
        #expect(secureBookMarkService.saveSecureBookMarkCalledNum == 1)
    }
    @Test("ホームディレクトリ以下のフォルダを指定した場合、警告アラートが表示されること。また,OKを選択した場合,正常にブックマークが保存されること")
    func testSaveSecureBookMark_HomeSubdirectoryWarning() async {
        FileSecureBookMarkTestMockNSAlertService.reset()
        let nsAlertService = FileSecureBookMarkTestMockNSAlertService.self
        let secureBookMarkService = FileSecureBookMarkTestMockSecureBookMarkService()
        let nsOpenPanelService = FileSecureBookMarkTestMockNSOpenPanelService()
        nsOpenPanelService.runModalResult = .OK
        nsOpenPanelService.secureBookMarkUrlToReturn = URL(fileURLWithPath: nsOpenPanelService.getNSHomeDirectory() + "/Documents")
        let fileSecureBookMark = FileSecureBookMark(
            nsAlertService: nsAlertService,
            secureBookMarkService: secureBookMarkService,
            nsOpenPanelService: nsOpenPanelService
        )
        FileSecureBookMarkTestMockNSAlertService.userSelectResult = true // ユーザーがOKを選択したと仮定
        await fileSecureBookMark.saveSecureBookMark()
        #expect(nsOpenPanelService.runModalCalledCount == 1)
        #expect(nsAlertService.showAlertWithUserSelectCalledCount == 1)
        #expect(nsAlertService.shownAlerts[0].title == "権限が小さいです")
        #expect(nsAlertService.shownAlerts[0].message == "ホームディレクトリより下のフォルダが指定されました。一部のフォルダでは正常に動作しない可能性があります。よろしいですか？")
        #expect(secureBookMarkService.saveSecureBookMarkCalledNum == 1)
    }

    @Test("ホームディレクトリ以下のフォルダを指定した場合、警告アラートが表示されること。また,キャンセルを選択した場合,ブックマークは保存されないこと")
    func testSaveSecureBookMark_HomeSubdirectoryWarning_Cancel() async {
        FileSecureBookMarkTestMockNSAlertService.reset()
        let nsAlertService = FileSecureBookMarkTestMockNSAlertService.self
        let secureBookMarkService = FileSecureBookMarkTestMockSecureBookMarkService()
        let nsOpenPanelService = FileSecureBookMarkTestMockNSOpenPanelService()
        nsOpenPanelService.runModalResult = .OK
        nsOpenPanelService.secureBookMarkUrlToReturn = URL(fileURLWithPath: nsOpenPanelService.getNSHomeDirectory() + "/Documents")
        let fileSecureBookMark = FileSecureBookMark(
            nsAlertService: nsAlertService,
            secureBookMarkService: secureBookMarkService,
            nsOpenPanelService: nsOpenPanelService
        )
        FileSecureBookMarkTestMockNSAlertService.userSelectResult = false // ユーザーがキャンセルを選択したと仮定
        await fileSecureBookMark.saveSecureBookMark()
        #expect(nsOpenPanelService.runModalCalledCount == 1)
        #expect(nsAlertService.showAlertWithUserSelectCalledCount == 1)
        #expect(nsAlertService.shownAlerts[0].title == "権限が小さいです")
        #expect(nsAlertService.shownAlerts[0].message == "ホームディレクトリより下のフォルダが指定されました。一部のフォルダでは正常に動作しない可能性があります。よろしいですか？")
        #expect(secureBookMarkService.saveSecureBookMarkCalledNum == 0)
        #expect(nsAlertService.showAlertCalledCount == 0)
    }

    @Test("secureBookMarkService.saveSecureBookMarkが何らかのエラーを投げた場合、対応するアラートを表示すること")
    func testSaveSecureBookMark_throwSomething() async {
        FileSecureBookMarkTestMockNSAlertService.reset()
        let nsAlertService = FileSecureBookMarkTestMockNSAlertService.self
        let secureBookMarkService = FileSecureBookMarkTestMockSecureBookMarkService()
        let nsOpenPanelService = FileSecureBookMarkTestMockNSOpenPanelService()
        nsOpenPanelService.runModalResult = .OK
        nsOpenPanelService.secureBookMarkUrlToReturn = URL(fileURLWithPath: nsOpenPanelService.getNSHomeDirectory())
        let fileSecureBookMark = FileSecureBookMark(
            nsAlertService: nsAlertService,
            secureBookMarkService: secureBookMarkService,
            nsOpenPanelService: nsOpenPanelService
        )
        secureBookMarkService.raisedNormalErrorOnSaveSecureBookMark = NSError(domain: "TestErrorDomain", code: -1, userInfo: nil)
        secureBookMarkService.isRaiseErrorOnSaveSecureBookMark = true
        await fileSecureBookMark.saveSecureBookMark()
        #expect(nsOpenPanelService.runModalCalledCount == 1)
        #expect(nsAlertService.showAlertWithUserSelectCalledCount == 0)
        #expect(nsAlertService.showAlertCalledCount == 1)
        #expect(nsAlertService.shownAlerts[0].title == "不明なエラー")
        #expect(nsAlertService.shownAlerts[0].message == "不明なエラーが発生しました。再度実行してください。")
    }
}
