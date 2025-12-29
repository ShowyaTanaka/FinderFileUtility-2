import Foundation

struct UserDefaultsModel: UserDefaultsModelProtocol {
    let suiteName = "group.com.ShoyaTanaka.FFU2"

    @discardableResult
    func setValue(value: Any, forKey: String) -> Bool {
        guard let userDefaults = UserDefaults(suiteName: self.suiteName) else {return false}
        userDefaults.set(value, forKey: forKey)
        return true
    }

    func getStringValue(forKey: String) -> String? {
        guard let userDefaults = UserDefaults(suiteName: self.suiteName) else {return nil}
        return userDefaults.string(forKey: forKey)
    }

    func getArrayValue(forKey: String) -> [Any]? {
        guard let userDefaults = UserDefaults(suiteName: self.suiteName) else {return nil}
        return userDefaults.array(forKey: forKey)
    }

    func getDictionaryValue(forKey: String) -> [String: Any]? {
        guard let userDefaults = UserDefaults(suiteName: suiteName) else { return nil }
        return userDefaults.dictionary(forKey: forKey)
    }

    func getDataValue(forKey: String) -> Data? {
        guard let userDefaults = UserDefaults(suiteName: suiteName) else { return nil }
        return userDefaults.data(forKey: forKey)
    }

    func getStringArrayValue(forKey: String) -> [String]? {
        guard let userDefaults = UserDefaults(suiteName: suiteName) else { return nil }
        return userDefaults.stringArray(forKey: forKey)
    }

    func getBoolValue(forKey: String) -> Bool {
        guard let userDefaults = UserDefaults(suiteName: suiteName) else { return false }
        return userDefaults.bool(forKey: forKey)
    }

    @discardableResult
    func removeValue(forKey: String) -> Bool {
        guard let userDefaults = UserDefaults(suiteName: suiteName) else { return false }
        userDefaults.removeObject(forKey: forKey)
        return true
    }

}
