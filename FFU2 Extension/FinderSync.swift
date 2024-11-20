//
//  FinderSync.swift
//  FFU2 Extension
//
//  Created by ShowyaTanaka on 2024/11/18.
//

import Cocoa
import FinderSync
// TODO: XPCを用いてアプリ側にターゲットディレクトリの情報を送り、アプリ側からそこに読み書きする形へ。

class FinderSync: FIFinderSync {
    private let keyForAvailableDirectory = "availableDirectory"
    var myFolderURL = URL(fileURLWithPath: "")
    override init() {
        if let userDefaults = UserDefaults(suiteName: "com.ShoyaTanaka.FFU2") {
            if let directoryPath = userDefaults.string(forKey: self.keyForAvailableDirectory) {
                self.myFolderURL = URL(fileURLWithPath: directoryPath)
            }
        }
        super.init()
        NSLog("FinderSync() launched from %@", Bundle.main.bundlePath as NSString)

        // Set up the directory we are syncing.
        FIFinderSyncController.default().directoryURLs = [self.myFolderURL]

    }

    // MARK: - Primary Finder Sync protocol methods

    override func beginObservingDirectory(at url: URL) {
        // The user is now seeing the container's contents.
        // If they see it in more than one view at a time, we're only told once.
        NSLog("beginObservingDirectoryAtURL: %@", url.path as NSString)
    }

    override func endObservingDirectory(at url: URL) {
        // The user is no longer seeing the container's contents.
        NSLog("endObservingDirectoryAtURL: %@", url.path as NSString)
    }

    override func requestBadgeIdentifier(for url: URL) {
        NSLog("requestBadgeIdentifierForURL: %@", url.path as NSString)

        // For demonstration purposes, this picks one of our two badges, or no badge at all, based on the filename.
        let whichBadge = abs(url.path.hash) % 3
        let badgeIdentifier = ["", "One", "Two"][whichBadge]
        FIFinderSyncController.default().setBadgeIdentifier(badgeIdentifier, for: url)
    }

    // MARK: - Menu and toolbar item support

    override var toolbarItemName: String {
        return "FinderSy"
    }

    override var toolbarItemToolTip: String {
        return "FinderSy: Click the toolbar item for a menu."
    }

    override var toolbarItemImage: NSImage {
        return NSImage(named: NSImage.cautionName)!
    }

    override func menu(for _: FIMenuKind) -> NSMenu {
        // Produce a menu for the extension.
        let menu = NSMenu(title: "")
        menu.addItem(withTitle: "Example Menu Item", action: #selector(sampleAction(_:)), keyEquivalent: "")
        return menu
    }

    @IBAction func sampleAction(_ sender: AnyObject?) {
        let target = FIFinderSyncController.default().targetedURL()
        let items = FIFinderSyncController.default().selectedItemURLs()

        let item = sender as! NSMenuItem
        NSLog("sampleAction: menu item: %@, target = %@, items = ", item.title as NSString, target!.path as NSString)
        for obj in items! {
            NSLog("    %@", obj.path as NSString)
        }
    }
}
