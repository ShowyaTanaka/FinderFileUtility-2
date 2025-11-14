//
//  SaveSecureBookMarkStatus.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/11/09.
//
import Foundation

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
