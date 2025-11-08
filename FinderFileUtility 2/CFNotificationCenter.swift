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
            /*guard let info = userInfo as? [String: Any] else {
                print("OUT")
                return
            }*/
            let userInfo:[String:String] = ["message": "珍棒"]
            
            NotificationCenter.default.post(name: .notifyEditFileName,object: nil, userInfo: userInfo)
            print("送信しました！")
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
