import Foundation

struct UserDefaultsModel {
    static var suiteName = "group.com.ShoyaTanaka.FFU2"

    @discardableResult
    static func setValue(value: Any, forKey: String) -> Bool {
        guard let userDefaults = UserDefaults(suiteName: self.suiteName) else {return false}
        userDefaults.set(value, forKey: forKey)
        return true
    }

    static func getStringValue(forKey: String) -> String? {
        guard let userDefaults = UserDefaults(suiteName: self.suiteName) else {return nil}
        return userDefaults.string(forKey: forKey)
    }

    static func getArrayValue(forKey: String) -> [Any]? {
        guard let userDefaults = UserDefaults(suiteName: self.suiteName) else {return nil}
        return userDefaults.array(forKey: forKey)
    }

    static func getDictionaryValue(forKey: String) -> [String: Any]? {
        guard let userDefaults = UserDefaults(suiteName: suiteName) else { return nil }
        return userDefaults.dictionary(forKey: forKey)
    }

    static func getDataValue(forKey: String) -> Data? {
        guard let userDefaults = UserDefaults(suiteName: suiteName) else { return nil }
        return userDefaults.data(forKey: forKey)
    }

    static func getStringArrayValue(forKey: String) -> [String]? {
        guard let userDefaults = UserDefaults(suiteName: suiteName) else { return nil }
        return userDefaults.stringArray(forKey: forKey)
    }

    static func getBoolValue(forKey: String) -> Bool {
        guard let userDefaults = UserDefaults(suiteName: suiteName) else { return false }
        return userDefaults.bool(forKey: forKey)
    }

    @discardableResult
    static func removeValue(forKey: String) -> Bool {
        guard let userDefaults = UserDefaults(suiteName: suiteName) else { return false }
        userDefaults.removeObject(forKey: forKey)
        return true
    }

}
