import Foundation

protocol SecureBookMarkServiceProtocol {
    func getSecureBookMarkStringFullPath() -> String?
    func isBookMarkExists() -> Bool
    func getSecureBookMarkUrl() -> URL?
    func saveSecureBookMark(bookmark: Data?) throws
    func isSecureBookMarkAvailableOnPath(path: String) -> Bool
    func getSecureUrlFromFullPath(path: String) -> URL?
}
