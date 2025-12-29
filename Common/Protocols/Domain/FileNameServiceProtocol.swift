protocol FileNameServiceProtocol{
    func writeDefaultFileNameData(newFileName: String)
    func getDefaultFileNameData() -> String
    func renameFileName(fileName: String, index: Int) -> String
}
