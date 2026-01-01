import Foundation

struct SecureBookMarkService: SecureBookMarkServiceProtocol {
    private let keyForSecureBookmark = "secureBookMark"
    private let keyForAvailableDirectory = "availableDirectory"
    private let userDefaultsModel: UserDefaultsModelProtocol

    init(userDefaultsModel: UserDefaultsModelProtocol) {
        self.userDefaultsModel = userDefaultsModel
    }

    private func validateSecureBookMarkData(bookMarkData: Data?) -> Data? {
        // secureBookMarkがそもそもない場合はnilを返す。
        guard let bookmark = bookMarkData else { return nil }
        // 一部フォルダにのみ限定して許可し、その後リネームしてしまった場合、正常にトークンが利用できなくなるためそれに備えて
        var folderNameChanged = false
        guard let _ = try? URL(resolvingBookmarkData: bookmark, options: .withSecurityScope, bookmarkDataIsStale: &folderNameChanged) else {
            return nil
        }
        return !folderNameChanged ? bookMarkData : nil
    }

    func getSecureBookMarkStringFullPath() -> String? {
        // SecureBookMarkの検証をする
        guard let bookmarkData = self.validateSecureBookMarkData(bookMarkData: UserDefaultsModel().getDataValue(forKey: self.keyForSecureBookmark)) else {
            return nil
        }
        var folderNameChanged = false
        guard let url = try? URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, bookmarkDataIsStale: &folderNameChanged) else {
            return nil
        }
        // 正常にトークンが利用できる場合のみpathを返す
        return url.path()
    }

    func isBookMarkExists() -> Bool {
        return self.userDefaultsModel.getDataValue(forKey: self.keyForSecureBookmark) != nil
    }

    func getSecureBookMarkUrl() -> URL? {
        // SecureBookMarkの検証をする
        guard let bookmarkData = self.validateSecureBookMarkData(bookMarkData: self.userDefaultsModel.getDataValue(forKey: self.keyForSecureBookmark)) else {
            return nil
        }
        var folderNameChanged = false
        guard let url = try? URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, bookmarkDataIsStale: &folderNameChanged) else {
            return nil
        }
        // 正常にトークンが利用できる場合のみURLを返す
        return url
    }

    func saveSecureBookMark(bookmark: Data?) throws {
        /*
         UserDefaultsに検証して保存する。
         生成したsecurity-scoped-bookmarkはアプリ再起動時にそのままでは消えてしまうため、UserDefaultsに保存している。

         NOTE: UserDefaultsにこのまま保存することに関して、現段階ではセキュリティ上の懸念がない
         (そもそもこの情報が他のアプリから見える状況になってしまっている時点でこの情報は必要ないため)と考えるが、
         追加の懸念点が発生した場合はKeyChainを用いた実装に切り替える。
         */

        // ブックマークが存在するか
        guard let bookmarkData = bookmark else { throw SaveSecureBookMarkError.bookmarkMissing }

        // 解決できるか + stale か
        var folderNameChanged = false
        guard let url = try? URL(
            resolvingBookmarkData: bookmarkData,
            options: .withSecurityScope,
            bookmarkDataIsStale: &folderNameChanged
        ) else {
            throw SaveSecureBookMarkError.failedToResolveBookmark
        }
        guard folderNameChanged != true else { throw SaveSecureBookMarkError.bookmarkStale }

        // 保存
        guard self.userDefaultsModel.setValue(value: bookmarkData, forKey: self.keyForSecureBookmark) else {
            throw SaveSecureBookMarkError.failedToPersist
        }
        guard self.userDefaultsModel.setValue(value: url.path(), forKey: self.keyForAvailableDirectory) else {
            throw SaveSecureBookMarkError.failedToPersist
        }

        // 正常に保管できているか検証
        guard self.getSecureBookMarkStringFullPath() == url.path() else {
            throw SaveSecureBookMarkError.failedToPersist
        }
        guard bookmarkData == self.userDefaultsModel.getDataValue(forKey: self.keyForSecureBookmark) else {
            throw SaveSecureBookMarkError.failedToPersist
        }
    }

    func isSecureBookMarkAvailableOnPath(path: String) -> Bool {
        guard let bookMarkUrlString = self.getSecureBookMarkStringFullPath() else { return false }
        return path.contains(bookMarkUrlString)
    }

    func getSecureUrlFromFullPath(path: String) -> URL? {
        guard isSecureBookMarkAvailableOnPath(path: path) else { return nil }

        let targetPath = URL(
            fileURLWithPath: path,
            relativeTo: URL(fileURLWithPath: self.getSecureBookMarkStringFullPath()!)
        )
        // secureBookMarkURLに連結して返す
        return self.getSecureBookMarkUrl()?.appendingPathComponent(targetPath.relativeString)
    }
}
