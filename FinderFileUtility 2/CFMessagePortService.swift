//
//  CF.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/09/27.
//

import Foundation

protocol CFMessagePortHandlerProtocol: AnyObject {
    var portName: String {get}
    var CFMessageHandler: CFMessagePortCallBack {get}
    var cfMessagePortThread: Thread? {get set}
}

class CFMessageTestHandler: CFMessagePortHandlerProtocol {
    let portName: String = "com.ShoyaTanaka.FFU2.port"
    var viewModel = EditFileNameViewModel()
    lazy var CFMessageHandler: CFMessagePortCallBack = { (port, msgid, data, info) -> Unmanaged<CFData>? in
        print("メッセージを受信しました！")
        print("Message ID: \(msgid)")

        // 受信したデータをStringに変換して表示
        if let cfdata = data {
            let nsdata = cfdata as Data
            if let receivedString = String(data: nsdata, encoding: .utf8) {
                print("受信データ: \(receivedString)")
            }
        }
        self.viewModel
        
        return nil // 応答を返さない場合
    }
    var cfMessagePortThread: Thread?
}

// Note: Call this function with `&handler` to allow mutating the parameter.
func launchMessagePort(cfMessagePortHandler: CFMessagePortHandlerProtocol) {
    // メッセージポートの名前
    let thread = Thread {
        let portName = cfMessagePortHandler.portName as CFString

        var context = CFMessagePortContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        var shouldFreeInfo: DarwinBoolean = false

        // 2. CFMessagePortCreateLocalでローカルポートを作成
        guard let localPort = CFMessagePortCreateLocal(
            kCFAllocatorDefault,
            portName,
            cfMessagePortHandler.CFMessageHandler, // コールバック関数
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
    cfMessagePortHandler.cfMessagePortThread = thread
    cfMessagePortHandler.cfMessagePortThread!.start()
}
