import SwiftUI

struct CloseWindowButton: View {
    let title: String

    var body: some View {
        Button(title) {
            if let window = NSApp.keyWindow ?? NSApp.mainWindow {
                window.close()
            }
        }
    }
}

/*
 FIXME: macOS 26.1では,TextSelectionにバグが存在する可能性がある.(マルチバイト文字を含んだ状態で文字数でoffset指定するとうまく動かない) 発現条件は文字数<指定バイト数のとき(例:「あいうえお」は5文字,10バイトの文字列であるが,この場合であれば3文字目以降,つまり6バイト目以降を含んだ状態で範囲指定すると動作しなくなる) 将来的にmacOSのアップデートで修正された場合は,macOS 26.1までの26系だけ特別な制限をかける.
 */

struct CreateFileView: View {
    @FocusState private var isTextFieldFocused: Bool
    @State private var selection: TextSelection?
    @ObservedObject var viewModel: CreateFileViewModel

    init(viewModel: CreateFileViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Text("ファイル名を入力してください。")
            TextField("ファイル名", text: self.$viewModel.fileName, selection: $selection).focused($isTextFieldFocused)
                .onChange(of: isTextFieldFocused) {
                    guard self.viewModel.fileName != "" else { selection = nil; return }
                    let endOffset = self.viewModel.getFocusFileTextLength()
                    let end = self.viewModel.fileName.index(self.viewModel.fileName.startIndex, offsetBy: endOffset)
                    selection = .init(range: self.viewModel.fileName.startIndex..<end)
                }
            HStack(spacing: 10) {
                CloseWindowButton(title: "キャンセル")
                Button("作成") {
                    let status = self.viewModel.createFile()
                    if status {
                        self.viewModel.closeWindow()
                    }
                }.buttonStyle(.borderedProminent)
                .tint(.blue).keyboardShortcut(.defaultAction)
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTextFieldFocused = true
            }
        }
    }
}
