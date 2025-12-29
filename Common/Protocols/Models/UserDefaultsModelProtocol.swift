import Foundation

protocol UserDefaultsModelProtocol {
    func setValue(value: Any, forKey: String) -> Bool

    func getStringValue(forKey: String) -> String?

    func getArrayValue(forKey: String) -> [Any]?

    func getDictionaryValue(forKey: String) -> [String: Any]?

    func getDataValue(forKey: String) -> Data?

    func getStringArrayValue(forKey: String) -> [String]?

    func getBoolValue(forKey: String) -> Bool

    func removeValue(forKey: String) -> Bool
}
