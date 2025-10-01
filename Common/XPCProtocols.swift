//
//  XPCProtocols.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/09/27.
//
import Foundation
@objc protocol EditFileXPCProtocol: NSObjectProtocol {
    func editFileNotification(path: String, ext: String, with reply: @escaping (Bool) -> Void)
}
