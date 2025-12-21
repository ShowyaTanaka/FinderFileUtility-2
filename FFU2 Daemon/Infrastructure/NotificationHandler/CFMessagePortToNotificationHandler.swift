import Foundation

class CFMessagePortToNotificationHandler {
    /*
     CFNotificationCenterで発行された通知をもとに,Delegateを呼び出すサービス。
     */
    /* TODO: CFNotificationCenterを用いて,Sandbox下でのDistributedNotificationCenterでは実現できないことを実現している.そのため,macOSの将来的な変更に影響を受ける可能性が否定できない.代替APIが出た際はそちらの実装に置き換える. */

    private var pipeLineThread: Thread
    var pipeLineDelegate: CFMessagePortToNotificationHandlerDelegate

    private class PipeLineInfo {
        var portName: CFString
        var notificationName: Notification.Name
        init(portName: CFString, notificationName: Notification.Name) {
            self.portName = portName
            self.notificationName = notificationName
        }
    }

    private static func getCFMessagePortContext(infoPtr: UnsafeMutableRawPointer) -> CFMessagePortContext {
        return CFMessagePortContext(
            version: 0,
            info: infoPtr,
            retain: {(info: UnsafeRawPointer?) -> UnsafeRawPointer? in
                guard let info = info else {return nil }
                let unmanaged = Unmanaged<PipeLineInfo>.fromOpaque(info)
                _ = unmanaged.retain() // retain カウント +1
                return UnsafeRawPointer(unmanaged.toOpaque())
            },
            release: {(info: UnsafeRawPointer?) in
                guard let info = info else { return }
                Unmanaged<PipeLineInfo>.fromOpaque(info).release() // retain カウント -1
            },
            copyDescription: nil
        )
    }

    private static func createCFMessagePortThread(pipeLineInfo: PipeLineInfo) -> Thread {
        let pipeLineInfoClass = pipeLineInfo
        let portName = pipeLineInfoClass.portName
        let infoPtr = Unmanaged.passRetained(pipeLineInfoClass).toOpaque()
        var context = getCFMessagePortContext(infoPtr: infoPtr)
        print(portName)

        return Thread {
            var shouldFreeInfo: DarwinBoolean = false

            // 2. CFMessagePortCreateLocalでローカルポートを作成
            guard let localPort = CFMessagePortCreateLocal(
                kCFAllocatorDefault,
                portName,
                {(_ port: CFMessagePort?, _ msgid: Int32, _ data: CFData?, _ info: UnsafeMutableRawPointer?) -> Unmanaged<CFData>? in
                    guard let info else { return nil }
                    guard let cfdata = data as? Data else {return nil}
                    guard let receivedString = String(data: cfdata, encoding: .utf8) else {return nil}

                    let notificationPipelineInformation = Unmanaged<PipeLineInfo>.fromOpaque(info).takeUnretainedValue()
                    print("受信データ: \(receivedString)")
                    guard let message = try? JSONSerialization.jsonObject(with: cfdata, options: []) as? [String: String] else {
                        NSLog("JSONのシリアライズに失敗しました")
                        return nil
                    }
                    NotificationCenter.default.post(name: notificationPipelineInformation.notificationName, object: message)
                    print("送信しました！")

                    return nil
                }, // コールバック関数
                &context,
                &shouldFreeInfo
            ) else {
                fatalError("ローカルポートの作成に失敗しました。")
            }

            // 3. Run Loop Sourceを作成して、現在のRun Loopに追加
            let runLoopSource = CFMessagePortCreateRunLoopSource(kCFAllocatorDefault, localPort, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)

            print("\(portName) という名前でメッセージの待受を開始しました。")
            // アプリケーションが終了しないようにRun Loopを回し続ける
            CFRunLoopRun()
        }
    }

    init(pipeLineDelegate: CFMessagePortToNotificationHandlerDelegate) {
        self.pipeLineThread = CFMessagePortToNotificationHandler.createCFMessagePortThread(
            pipeLineInfo: PipeLineInfo(portName: pipeLineDelegate.portName, notificationName: pipeLineDelegate.notificationName))
        self.pipeLineDelegate = pipeLineDelegate
        NotificationCenter.default.addObserver(self.pipeLineDelegate, selector: self.pipeLineDelegate.callBackSelector, name: self.pipeLineDelegate.notificationName, object: nil)
    }

    func launchMessagePort() -> Bool {
        /*
         渡された情報を元に,情報を受け取った際にNotificationで通知するCFMessagePortを作成する関数。
         スレッドのライフタイムを外で管理するために,スレッドを返している。
         */
        self.pipeLineThread.name = "Thread_"
        self.pipeLineThread.start()
        return true
    }

}
