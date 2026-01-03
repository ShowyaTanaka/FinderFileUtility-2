import Testing
import Foundation
@testable import FFU2_Daemon

class TestFileManagementServiceFileRepository: FileIRepository {
    var existCount: Int? = nil
    var createdFileName: String? = nil
    func exists(path: URL) throws -> Bool {
        let fileName = path.lastPathComponent
        guard let count = existCount else {
            return false
        }
        let pattern = #"のコ.*?ー(\d+)\."#
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(fileName.startIndex..., in: fileName)
        guard let match = regex.firstMatch(in: fileName, range: range),
              let numberRange = Range(match.range(at: 1), in: fileName) else {
            // 〇〇のコピーとなっていないため、無条件で存在するものとして返し、リネームさせる。
            return true
        }
        let currentNumber = Int(fileName[numberRange])!
        NSLog("currentNumber: \(currentNumber), existCount: \(count)")
        return currentNumber < count
    }
    
    func create(path: URL, data: Data?) throws -> Bool {
        let fileName = path.lastPathComponent
        self.createdFileName = fileName
        return true
    }
}
