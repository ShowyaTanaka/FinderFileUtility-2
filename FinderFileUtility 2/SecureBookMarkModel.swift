//
//  ConfigMenuModel.swift
//  FinderFileUtility 2
//
//  Created by ShowyaTanaka on 2024/11/19.
//

import FinderSync

enum SaveSecureBookMarkStatus {
    // ConfigMenuModelのsaveSecureBookMarkForHomeDirectoryの結果を示す
    case ok
    case unsupporeted_directory // 現状ホームディレクトリ以外が指定された場合はこれを返す
    case smaller_permission_for_home_directory //ホームディレクトリの中でさらに小さいフォルダ(ex./home/hoge/fugaのfuga)が指定されたとき返す
    case canceled // 中断した場合これ
    case failed // 何らかの要因で失敗した場合これを返す
}
struct SaveSecureBookMarkResult {
    var bookmark: Data? = nil
    var status: SaveSecureBookMarkStatus = .failed
}

struct SecureBookMarkModel {
    private static let keyForSecureBookmark = "secureBookMark"
    private static let keyForAvailableDirectory = "availableDirectory"

    static func getSecureBookMarkStringUrl() -> String? {
        // secureBookMarkがそもそもない場合はnilを返す。
        guard let userDefaults = UserDefaults(suiteName: "com.ShoyaTanaka.FFU2") else {return nil}
       // userDefaults.set(nil, forKey: self.keyForSecureBookmark)
        guard let bookmark = userDefaults.data(forKey: self.keyForSecureBookmark) else { return nil }
        // 一部フォルダにのみ限定して許可し、その後リネームしてしまった場合、正常にトークンが利用できなくなるためそれに備えて
        var folderNameChanged = false
        // URL取得に失敗したら結局意味ないのでnilをリターン
        guard let url = try? URL(resolvingBookmarkData: bookmark, options: .withSecurityScope, bookmarkDataIsStale: &folderNameChanged) else { return nil }

        // 正常にトークンが利用できる場合のみpathを返す
        return !folderNameChanged ? url.path() : nil
    }
    
    static func saveSecureBookMark(bookmarkResult: SaveSecureBookMarkResult) -> Bool {
        /*
         UserDefaultsに検証して保存する。
         生成したsecurity-scoped-bookmarkはアプリ再起動時にそのままでは消えてしまうため、UserDefaultsに保存している。
         成功した場合のみtrueを返し、何らかの要因でしくじってる場合はfalseを返す。
         NOTE: UserDefaultsにこのまま保存することに関して、現段階ではセキュリティ上の懸念がない
         (そもそもこの情報が他のアプリから見える状況になってしまっている時点でこの情報は必要ないため)と考えるが、
         追加の懸念点が発生した場合はKeyChainを用いた実装に切り替える。
         */
        
        // ブックマークが存在するかをまず確認する。
        guard let bookmarkData = bookmarkResult.bookmark else {return false}
        guard let userDefaults = UserDefaults(suiteName: "com.ShoyaTanaka.FFU2") else {return false}
        // 一部フォルダにのみ限定して許可し、その後リネームしてしまった場合、正常にトークンが利用できなくなるためそれに備えて
        var folderNameChanged = false
        guard let url = try? URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, bookmarkDataIsStale: &folderNameChanged) else {return false}
        // フォルダ名が何らかの要因で変えられていた場合は保存しない。
        guard folderNameChanged != true else {return false}
        userDefaults.set(bookmarkData, forKey: self.keyForSecureBookmark)
        userDefaults.set(url.path(), forKey: self.keyForAvailableDirectory)
        // 正常に保管できているかどうかを結果として返す。
        guard self.getSecureBookMarkStringUrl() == url.path() else {return false}
        return bookmarkData == userDefaults.data(forKey: self.keyForSecureBookmark)
    }

    @MainActor //UI関係は主スレッドで実行しなければならないため、主スレッドで指定する。(ここではNSOpenPanel)
    static func createSecureBookMarkForHomeDirectory() async -> SaveSecureBookMarkResult {
        /*
         Finder拡張機能のうち、ファイルの新規作成機能を利用する際に必要となる「ファイルの書き込みができるBookMark」を生成、保存する関数。
         */
        var save_result = SaveSecureBookMarkResult()
        let result = await withCheckedContinuation { continuation in

                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseFiles = false
                panel.canChooseDirectories = true
                panel.directoryURL = URL(string: NSHomeDirectory())
                // NSOpenPanelのbeginを非同期処理で扱う
                panel.begin { result in
                    if result == .OK {
                        do {
                            let bookmarkData = try panel.url!.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                            var unused_status = false // 入れないと怒られるから入れただけで無意味である。
                            let url = try! URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, bookmarkDataIsStale: &unused_status)
                            let allowed_url = url.path().components(separatedBy: "/")
                            let home_url_array = NSHomeDirectory().components(separatedBy: "/")[0 ... 2]
                            
                            if allowed_url.prefix(3) != home_url_array {
                                // 現段階ではホームディレクトリ以外での書き込み動作は対象外であるため、他のディレクトリが指定された場合は弾く
                                save_result.status = .unsupporeted_directory
                            }
                            
                            else if allowed_url.count > 4 {
                                // allowed_urlの個数が3より多い場合、ホームディレクトリ下のなにかのフォルダを指定していることになるため、パーミッションとしては小さい
                                
                                save_result.status = .smaller_permission_for_home_directory
                                save_result.bookmark = bookmarkData
                            }
                            else {
                                // 正常な場合はokを返す
                                save_result.status = .ok
                                save_result.bookmark = bookmarkData
                            }
                        } catch {
                            save_result.status = .failed
                        }
                    }
                    else if result == .cancel {
                        save_result.status = .canceled
                    }
                    else {
                        save_result.status = .failed
                    }
                    continuation.resume(returning: save_result)
                }
            }

            return result
    }
}
