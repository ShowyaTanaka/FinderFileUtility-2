import Cocoa
@testable import FFU2_Daemon
import Testing

class FileSecureBookMarkTestMockNSOpenPanelService: NSOpenPanelServiceProtocol {
    var runModalResult: NSApplication.ModalResponse = .OK
    var runModalCalledCount: Int = 0
    var getBookmarkDataCalledCount: Int = 0
    var getSecureBookMarkUrlCalledCount: Int = 0
    var bookmarkDataToReturn: Data = Data()
    var secureBookMarkUrlToReturn: URL = URL(fileURLWithPath: "/home/hoge/")
    var isRaisedErrorOnGetBookmarkData: Bool = false
    var isRaisedErrorOnGetSecureBookMarkUrl: Bool = false
    var getBookMarkDataRaisedError: NSError = NSError(domain: "MockNSOpenPanelService getBookmarkData error", code: 1, userInfo: nil)
    var getSecureBookMarkUrlRaisedError: NSError = NSError(domain: "MockNSOpenPanelService getSecureBookMarkUrl error", code: 2, userInfo: nil)
    func getBookmarkData() throws -> Data {
        self.getBookmarkDataCalledCount += 1
        if isRaisedErrorOnGetBookmarkData {
            throw getBookMarkDataRaisedError
        }
        return bookmarkDataToReturn
    }
    func getNSHomeDirectory() -> String {
        var homeDir = NSHomeDirectory()
        // テスト環境では,Container環境下で動作しているため,ホームディレクトリが異なる場合がある.そのため,/Users/<ユーザー名>という形式に変換する.
        let homeDirComponents = homeDir.components(separatedBy: "/")
        if homeDirComponents.count >= 3 {
            homeDir = "/Users/\(homeDirComponents[2])"
        }
        return homeDir
    }

    func getSecureBookMarkUrl() throws -> String {
        self.getSecureBookMarkUrlCalledCount += 1
        if isRaisedErrorOnGetSecureBookMarkUrl {
            throw getSecureBookMarkUrlRaisedError
        }
        return secureBookMarkUrlToReturn.path()
    }

    func runModal(allowsMultipleSelection: Bool, canChooseFiles: Bool, canChooseDirectories: Bool, directoryPath: String) -> NSApplication.ModalResponse {
        self.runModalCalledCount += 1
        return runModalResult
    }
}
