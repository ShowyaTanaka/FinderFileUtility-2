import Foundation

protocol FileManagementServiceProtocol{
    func createFile(fileName: String, currentDirURL: URL) -> Bool
}
