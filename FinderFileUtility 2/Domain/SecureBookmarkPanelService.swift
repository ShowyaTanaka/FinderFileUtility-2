//
//  SecureBookmarkPanelService.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/09/23.
//
import Foundation
import FinderSync

struct SecureBookmarkPanelService {
    // 現実問題として,SecurebookMarkは1つでよいので,事実上HomeDirのNSPanelを呼び出している。
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
