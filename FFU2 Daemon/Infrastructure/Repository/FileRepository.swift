//

import Foundation

struct FileRepository: FileIRepository {
    let secureBookMarkService: SecureBookMarkServiceProtocol
    func exists(path: URL) throws -> Bool {
        guard let securityScopedURL = self.secureBookMarkService.getSecureBookMarkUrl() else {
            throw FileError.notAccessible}
        if !securityScopedURL.startAccessingSecurityScopedResource() {
            throw FileError.notAccessible
        }
        defer { securityScopedURL.stopAccessingSecurityScopedResource() }
        return FileManager.default.fileExists(atPath: path.path)
    }
    func create(path: URL, data: Data?) throws -> Bool {
        guard let sanitizedPath = path.path().removingPercentEncoding else {throw FileError.invalidPath}
        guard let securityScopedURL = self.secureBookMarkService.getSecureBookMarkUrl() else {
            throw FileError.notAccessible
        }
        if !securityScopedURL.startAccessingSecurityScopedResource() {
            throw FileError.notAccessible
        }
        defer { securityScopedURL.stopAccessingSecurityScopedResource() }
        return FileManager.default.createFile(atPath: sanitizedPath, contents: data)
    }
}
