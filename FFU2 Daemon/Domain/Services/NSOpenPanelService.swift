import Cocoa

struct NSOpenPanelService: NSOpenPanelServiceProtocol {
    var panel: NSOpenPanel
    init(nsOpenPanel: NSOpenPanel = NSOpenPanel()) {
        self.panel = nsOpenPanel
    }
    @MainActor
    func runModal(allowsMultipleSelection: Bool = false, canChooseFiles: Bool = true, canChooseDirectories: Bool = false, directoryPath: String) -> NSApplication.ModalResponse {
        panel.allowsMultipleSelection = allowsMultipleSelection
        panel.canChooseFiles = canChooseFiles
        panel.canChooseDirectories = canChooseDirectories
        panel.directoryURL = URL(string: directoryPath)
        let result = panel.runModal()
        return result
    }

    func getBookmarkData() throws -> Data {
        guard let url = panel.url else {throw NSError(domain: "nsPanelのURLが取得できません", code: 4, userInfo: nil)}
        guard let bookMarkData = try? url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil) else {throw NSError(domain: "ブックマークデータの取得に失敗しました", code: 5, userInfo: nil)}
        return bookMarkData
    }
    func getSecureBookMarkUrl() throws -> String {
        let bookMarkData = try self.getBookmarkData()
        var unused_status = false // 入れないと怒られるから入れただけで無意味である。
        guard let url = try? URL(resolvingBookmarkData: bookMarkData, options: .withSecurityScope, bookmarkDataIsStale: &unused_status) else {
                    throw NSError(domain: "BookMarkエラー", code: 4, userInfo: nil)
                }
        return url.path()
    }
}
