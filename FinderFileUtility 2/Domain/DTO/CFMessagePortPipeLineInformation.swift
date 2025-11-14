//
//  CFMessagePortPipeLineModel.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/11/08.
//
import Foundation


protocol CFMessagePortToNotificationPipeLineInformationProtocol {
    var portName: CFString {get set}
    var notificationName: Notification.Name {get set}
}
extension Notification.Name {
    static let notifyEditFileName = Notification.Name("notifyEditFileName")
}

struct CFMessagePortEditFilePipeLineInformation: CFMessagePortToNotificationPipeLineInformationProtocol{
    var notificationName: Notification.Name = .notifyEditFileName
    var portName = "group.com.ShoyaTanaka.FFU2.editfile" as CFString
}
