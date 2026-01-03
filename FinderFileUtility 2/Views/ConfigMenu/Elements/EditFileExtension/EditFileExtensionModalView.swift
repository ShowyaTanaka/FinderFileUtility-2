import SwiftUI
struct EditFileExtensionModalView: NSPanelManagementView {

    @FocusState var isFocused: Bool
    @StateObject var viewModel: EditFileExtensionModalViewModel
    init(viewModel: EditFileExtensionModalViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 10) {
            Text("拡張子名を入力してください。")
            TextField("ファイル名", text: self.$viewModel.fileExtension).frame(width: 250).focused($isFocused)
            Spacer().frame(height: 0)
            HStack(spacing: 10) {
                Spacer().frame(width: 100)
                /*CloseWindowButton(title: "キャンセル")
                CloseWindowButton(title: "追加") {
                    return self.viewModel.save()
                }.disabled(self.viewModel.fileExtension == "")
                    .buttonStyle(.borderedProminent)
                    .tint(self.viewModel.fileExtension == "" ? .gray : .blue)
                    .opacity(self.viewModel.fileExtension == "" ? 0.6 : 1.0).keyboardShortcut(.defaultAction)*/
                Button("キャンセル") {
                    self.viewModel.closeWindow()
                }
                Button("追加") {
                    let saveStatus = self.viewModel.save()
                    if saveStatus {
                        self.viewModel.closeWindow()
                    }
                }.disabled(self.viewModel.fileExtension == "")
                        .buttonStyle(.borderedProminent)
                        .tint(self.viewModel.fileExtension == "" ? .gray : .blue)
                        .opacity(self.viewModel.fileExtension == "" ? 0.6 : 1.0).keyboardShortcut(.defaultAction)

            }
        }.frame(width: 270, height: 120).onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isFocused = true
            }
        }
    }
}
