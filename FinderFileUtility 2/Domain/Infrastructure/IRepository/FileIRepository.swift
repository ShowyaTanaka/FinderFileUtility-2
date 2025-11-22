import Foundation

enum FileError: Error {
    case notAccessible
    case invalidPath
    case permissionDenied
}

protocol FileIRepository {
    func exists(path: URL) throws -> Bool
    func create(path: URL, data: Data?) throws -> Bool
}
