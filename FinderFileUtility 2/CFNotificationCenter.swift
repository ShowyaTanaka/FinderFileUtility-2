//
//  CF.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/09/24.
//
import Foundation

protocol CFNotificationCenterDelegate: AnyObject {
    func CFNotificationCallback(userInfo: [String: Any]?) -> Bool
}

protocol CFNotificationCenterService {
    var CFNotificationEventName: CFString {get}
}



class EditFileNameCFNotificationCenterService: CFNotificationCenterService {
    let CFNotificationEventName = "com.FFU2.EditFile" as CFString

    init(delegate: CFNotificationCenterDelegate) {
        let center = CFNotificationCenterGetDarwinNotifyCenter()
        let callBack: CFNotificationCallback = { center, observer, name, object, userInfo in
            //guard let observer = observer else { return }
            print("notify")
            print(userInfo)
            guard let info = userInfo as? [String: Any] else {
                print("OUT")
                return
            }
            
            // Notificationに変換して通知する。
            NotificationCenter.default.post(name: .notifyEditFileName, object: info)
        }
        CFNotificationCenterAddObserver(
            center,
            Unmanaged.passUnretained(self).toOpaque(), // observerとしてselfを渡す
            callBack, // グローバル関数
            CFNotificationEventName,
            nil,
            .deliverImmediately
        )
    }

}
