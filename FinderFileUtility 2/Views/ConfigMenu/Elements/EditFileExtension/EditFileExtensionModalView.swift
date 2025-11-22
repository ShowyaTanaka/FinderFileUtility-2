import SwiftUI
struct EditFileExtensionModalView: NSPanelManagementView{
    
    @Environment(\.dismiss) var dismiss
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
                Button("キャンセル") {
                    self.viewModel.isWindowClose = true
                }
                Button("追加"){
                    let saveStatus = self.viewModel.save()
                    if saveStatus {
                        self.viewModel.isWindowClose = true
                    }
                    }.buttonStyle(.borderedProminent)
                    .tint(.blue).keyboardShortcut(.defaultAction)

            }
        }.frame(width: 270, height: 120).onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isFocused = true
            }
        }
    }
}

