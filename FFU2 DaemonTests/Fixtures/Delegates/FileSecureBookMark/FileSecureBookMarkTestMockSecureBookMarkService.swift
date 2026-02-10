import Cocoa
@testable import FFU2_Daemon
import Testing
class FileSecureBookMarkTestMockSecureBookMarkService: SecureBookMarkServiceProtocol {
    var getSecureBookMarkStringFullPathCalledNum = 0
    var isBookMarkExistsCalledNum = 0
    var getSecureBookMarkUrlCalledNum = 0
    var saveSecureBookMarkCalledNum = 0
    var isSecureBookMarkAvailableOnPathCalledNum = 0
    var getSecureUrlFromFullPathCalledNum = 0
    var getSecureBookMarkStringFullPathReturnValue: String?
    var isBookMarkExistsReturnValue: Bool = false
    var getSecureBookMarkUrlReturnValue: URL?
    var isSecureBookMaekAvailableOnPathReturnValue: Bool = false
    var getSecureUrlFromFullPathReturnValue: URL?
    var isRaiseErrorOnSaveSecureBookMark: Bool = false
    var raisedErrorOnSaveSecureBookMark: SaveSecureBookMarkError?
    var raisedNormalErrorOnSaveSecureBookMark: Error?
    func getSecureBookMarkStringFullPath() -> String? {
        getSecureBookMarkStringFullPathCalledNum += 1
        return getSecureBookMarkStringFullPathReturnValue
    }

    func isBookMarkExists() -> Bool {
        isBookMarkExistsCalledNum += 1
        return isBookMarkExistsReturnValue
    }

    func getSecureBookMarkUrl() -> URL? {
        getSecureBookMarkUrlCalledNum += 1
        return getSecureBookMarkUrlReturnValue
    }

    func saveSecureBookMark(bookmark: Data?) throws {
        saveSecureBookMarkCalledNum += 1
        if self.isRaiseErrorOnSaveSecureBookMark {
            guard let error = self.raisedErrorOnSaveSecureBookMark else {
                guard let normalError = self.raisedNormalErrorOnSaveSecureBookMark else {
                    NSLog("エラーが指定されていません。")
                    return
                }
                throw normalError
            }
            throw error
        }

    }

    func isSecureBookMarkAvailableOnPath(path: String) -> Bool {
        isSecureBookMarkAvailableOnPathCalledNum += 1
        return isSecureBookMaekAvailableOnPathReturnValue
    }

    func getSecureUrlFromFullPath(path: String) -> URL? {
        getSecureUrlFromFullPathCalledNum += 1
        return getSecureUrlFromFullPathReturnValue
    }

}
