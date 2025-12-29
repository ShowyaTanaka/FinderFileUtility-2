protocol FileExtensionServiceProtocol {
    func getRegisteredExtension() -> [String]
    func setRegisteredExtension(_ newArray: [String]) -> Bool
}
