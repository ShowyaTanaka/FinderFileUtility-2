//
//  CF.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/09/27.
//

import Foundation

// Global C-compatible callback that does not capture Swift context
func CFMessagePortCallback(_ port: CFMessagePort?, _ msgid: Int32, _ data: CFData?, _ info: UnsafeMutableRawPointer?) -> Unmanaged<CFData>? {
    print("メッセージを受信しました！")
    print("Message ID: \(msgid)")
    guard let info else { return nil }
    guard let cfdata = data as Data? else {return nil}
    guard let receivedString = String(data: cfdata, encoding: .utf8) else {return nil}
    
    let notificationPipelineInformation = Unmanaged<PipeLineInfo>.fromOpaque(info).takeUnretainedValue()
    print("受信データ: \(receivedString)")
    let message: [String: String] = ["message": "珍棒"]
    print(notificationPipelineInformation.notificationName)
    NotificationCenter.default.post(name: notificationPipelineInformation.notificationName, object: message)
    
    print("送信しました！")

    return nil
}
private class PipeLineInfo {
    var portName: CFString
    var notificationName: Notification.Name
    init(portName: CFString, notificationName: Notification.Name) {
        self.portName = portName
        self.notificationName = notificationName
    }
}

protocol CFMessagePortToNotificationPipelineInformationProtocol {
    var portName: CFString {get set}
    var notificationName: Notification.Name {get set}
}

struct CFMessagePortEditFilePipelineInformation: CFMessagePortToNotificationPipelineInformationProtocol{
    var notificationName: Notification.Name = .notifyEditFileName
    var portName = "group.com.ShoyaTanaka.FFU2.editfile" as CFString
}
func retainCallback(_ info: UnsafeRawPointer?) -> UnsafeRawPointer? {
    guard let info = info else { print("ERR"); return nil }
    let unmanaged = Unmanaged<PipeLineInfo>.fromOpaque(info)
    _ = unmanaged.retain() // retain カウント +1
    return UnsafeRawPointer(unmanaged.toOpaque())
}

func releaseCallback(_ info: UnsafeRawPointer?) {
    guard let info = info else { return }
    Unmanaged<PipeLineInfo>.fromOpaque(info).release() // retain カウント -1
}
// Note: Call this function with `&handler` to allow mutating the parameter.
func launchMessagePort(pipeLineInfo: CFMessagePortEditFilePipelineInformation) -> Thread {
    let portName = pipeLineInfo.portName
    let pipeLineInfoClass = PipeLineInfo(portName: pipeLineInfo.portName , notificationName: pipeLineInfo.notificationName)
    let infoPtr = Unmanaged.passRetained(pipeLineInfoClass).toOpaque()
    // メッセージポートの名前
    let thread = Thread {
        var context = CFMessagePortContext(
            version: 0,
            info: infoPtr,
            retain: retainCallback,
            release: releaseCallback,
            copyDescription: nil
        )
        var shouldFreeInfo: DarwinBoolean = false

        // 2. CFMessagePortCreateLocalでローカルポートを作成
        guard let localPort = CFMessagePortCreateLocal(
            kCFAllocatorDefault,
            portName,
            CFMessagePortCallback, // コールバック関数（C関数ポインタ）
            &context, // コンテキスト情報（今回はnil）
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
    thread.name="cfMessagePort_"
    thread.start()
    return thread
}
