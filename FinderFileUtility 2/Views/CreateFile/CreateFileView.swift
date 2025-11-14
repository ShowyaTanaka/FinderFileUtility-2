//
//  EditFileNameView.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/09/21.
//
import SwiftUI

struct CreateFileView: NSPanelManagementView {
    @FocusState private var isTextFieldFocused: Bool
    @State private var selection: TextSelection? = nil
    var isCloseWindow = isCloseWindowStatus()
    @StateObject var viewModel: CreateFileViewModel
    init(viewModel: CreateFileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack {
            Text("ファイル名を入力してください。")
            TextField("ファイル名", text: self.$viewModel.fileName, selection: $selection).focused($isTextFieldFocused)
                .onChange(of: isTextFieldFocused) {
                    guard self.viewModel.fileName != "" else { selection = nil; return }
                    let endOffset = self.viewModel.getFocusFileTextLength()
                    let end = self.viewModel.fileName.index(self.viewModel.fileName.startIndex, offsetBy: endOffset)
                    print(end)
                    
                    selection = .init(range: self.viewModel.fileName.startIndex..<end)
                }
            HStack(spacing: 10){
                Button("キャンセル") {
                    self.closeWindow()
                }
                Button("作成") {
                    let createFileStatus = self.viewModel.createFile()
                    if !createFileStatus {
                        let alert = NSAlert()
                        alert.messageText = "ファイル作成に失敗しました。"
                        alert.addButton(withTitle: "OK")
                        _ = alert.runModal()
                    }
                    else {
                        self.closeWindow()
                    }
                }
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTextFieldFocused = true
            }
        }
    }
}

