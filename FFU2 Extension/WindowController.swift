//
//  WindowController.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/09/24.
//
import SwiftUI
class MyViewController: NSHostingController<EditFileNameView> {

    override func viewWillAppear() {
        super.viewWillAppear()
        // ウィンドウを常に最前面に表示する
        view.window?.level = .floating
        // view.window がまだ nil の場合は viewDidAppear でも良い
        view.window?.setContentSize(NSSize(width: 400, height: 200))
    }

}
