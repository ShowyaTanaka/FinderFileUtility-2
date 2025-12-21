import Foundation
@objc protocol CFMessagePortToNotificationHandlerDelegate {
    var notificationName: Notification.Name {get}
    var portName: CFString {get}
    @objc optional func callback()
    var callBackSelector: Selector {get}
}
