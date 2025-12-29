import Foundation

protocol SecureBookMarkServiceProtocol {
    func getSecureBookMarkStringFullPath() -> String?
    func isBookMarkExists() -> Bool
    func getSecureBookMarkUrl() -> URL?
    func saveSecureBookMark(bookmark: Data?) -> Bool
    func isSecureBookMarkAvailableOnPath(path: String) -> Bool
    func getSecureUrlFromFullPath(path: String) -> URL?
}

