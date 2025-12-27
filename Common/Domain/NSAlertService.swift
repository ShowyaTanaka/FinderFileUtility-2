import Cocoa

struct NSAlertService {
    static func showAlert(title: String, message: String) {
        /*
         ユーザーの選択肢無しでアラートを表示する。
         */
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        _ = alert.runModal()
    }
    static func showAlertWithUserSelect(title: String, message: String) -> Bool {
        /*
         ユーザーが選択できるアラートを表示する。
         OKが押された場合はtrueを、それ以外ならfalseを返す。
         */
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        alert.buttons[0].tag = NSApplication.ModalResponse.OK.rawValue
        alert.addButton(withTitle: "キャンセル")
        alert.buttons[1].tag = NSApplication.ModalResponse.cancel.rawValue
        let result = alert.runModal()
        if result == .OK {
            return true
        } else {
            return false
        }
    }
}
