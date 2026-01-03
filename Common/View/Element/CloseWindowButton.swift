import SwiftUI
import AppKit

private var closingKey: UInt8 = 0

struct CloseWindowButton: NSViewRepresentable {
    /// ボタン表示
    let title: String
    /// クリック時に行いたい処理（任意）
    let onTap: () -> Bool

    init(
        title: String = "閉じる",
        onTap: @escaping () -> Bool = {
            return true
        }
    ) {
        self.title = title
        self.onTap = onTap
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onTap: onTap)
    }

    func makeNSView(context: Context) -> NSButton {
        let button = NSButton(title: title, target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        button.bezelStyle = .rounded
        return button
    }

    func updateNSView(_ nsView: NSButton, context: Context) {
        // SwiftUI側のクロージャ更新に追従
        context.coordinator.onTap = onTap
        nsView.title = title
    }

    final class Coordinator: NSObject {
        var onTap: () -> Bool

        init(onTap: @escaping () -> Bool) {
            self.onTap = onTap
        }

        @objc func handleTap(_ sender: NSButton) {
            // 1) 任意処理
            let isApproveClosed = onTap()
            print("CloseWindowButton: onTap returned \(isApproveClosed)")

            // 2) onTapがtrueを返した場合のみウィンドウを閉じる
            guard isApproveClosed else { return }
            // sender.window は NSPanel でも NSWindow でも来る
            guard let window = sender.window else {
                NSLog("CloseWindowButton: sender.window is nil")
                return
            }
            // ★二重 close 防止
            if (objc_getAssociatedObject(window, &closingKey) as? Bool) == true { return }
            objc_setAssociatedObject(window, &closingKey, true, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            window.orderOut(nil)
            window.close()

            DispatchQueue.main.async {
                window.contentView = nil
            }

          /*  if let stillWindow = sender.window {
                if stillWindow.isVisible {         // still visible → fallback
                    stillWindow.close()
                }
            }
           */
        }
    }
}
