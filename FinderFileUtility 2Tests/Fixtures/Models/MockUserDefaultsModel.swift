@testable import FinderFileUtility_2
import Foundation
import Testing

class MockUserDefaultsModel: UserDefaultsModelProtocol {
    let suiteName = "group.com.ShoyaTanaka.FFU2"
    var mockDefaults: [String: Any ] = [:]

    @discardableResult
    func setValue(value: Any, forKey: String) -> Bool {
        self.mockDefaults[forKey] = value
        return true
    }

    func getStringValue(forKey: String) -> String? {
        return self.mockDefaults[forKey] as? String
    }

    func getArrayValue(forKey: String) -> [Any]? {
        return self.mockDefaults[forKey] as? [Any]
    }

    func getDictionaryValue(forKey: String) -> [String: Any]? {
        return self.mockDefaults[forKey] as? [String: Any]
    }

    func getDataValue(forKey: String) -> Data? {
        return self.mockDefaults[forKey] as? Data
    }

    func getStringArrayValue(forKey: String) -> [String]? {
        return self.mockDefaults[forKey] as? [String]
    }

    func getBoolValue(forKey: String) -> Bool {
        if let value = self.mockDefaults[forKey] as? Bool {
            return value
        }
        return false
    }

    @discardableResult
    func removeValue(forKey: String) -> Bool {
        self.mockDefaults.removeValue(forKey: forKey)
        return true
    }

}
