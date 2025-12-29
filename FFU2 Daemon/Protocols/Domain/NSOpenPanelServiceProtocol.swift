import Cocoa

protocol NSOpenPanelServiceProtocol {
    func runModal(allowsMultipleSelection: Bool, canChooseFiles: Bool, canChooseDirectories: Bool, directoryPath: String) -> NSApplication.ModalResponse
    func getBookmarkData() throws -> Data
    func getSecureBookMarkUrl() throws -> String
}
