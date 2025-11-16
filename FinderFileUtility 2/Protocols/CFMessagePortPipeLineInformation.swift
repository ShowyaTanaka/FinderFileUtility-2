import Foundation

extension Notification.Name {
    static let notifyEditFileName = Notification.Name("notifyEditFileName")
}

protocol CFMessagePortToNotificationPipeLineInformationProtocol {
    var portName: CFString {get set}
    var notificationName: Notification.Name {get set}
}

struct CFMessagePortEditFilePipeLineInformation: CFMessagePortToNotificationPipeLineInformationProtocol{
    var notificationName: Notification.Name = .notifyEditFileName
    var portName = "group.com.ShoyaTanaka.FFU2.editfile" as CFString
}
