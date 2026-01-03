import SwiftUI

struct FileNameConfigModalView: NSPanelManagementView {
    @FocusState var isFocused: Bool
    @ObservedObject var viewModel: FileNameConfigModalViewModel
    init(viewModel: FileNameConfigModalViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 10) {
            Text("新規ファイルに利用する名前を入力してください。")
            TextField("ファイル名", text: self.$viewModel.fileName).frame(width: 250).focused($isFocused)
            Spacer().frame(height: 0)
            HStack(spacing: 10) {
                Spacer().frame(width: 100)
                Button("キャンセル") {

                    self.viewModel.closeWindow()
                }
                Button("変更") {
                    self.viewModel.updateDefaultFileNameData()
                }.buttonStyle(.borderedProminent)
                .tint(.blue).keyboardShortcut(.defaultAction)
                .disabled(viewModel.fileName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

            }
        }.frame(width: 270, height: 120).onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isFocused = true
            }
        }
    }
}
