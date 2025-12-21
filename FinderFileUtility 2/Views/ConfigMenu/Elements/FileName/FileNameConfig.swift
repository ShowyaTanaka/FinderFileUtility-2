import Foundation
import SwiftUI
struct FileNameConfig: View {
    @StateObject var viewModel: FileNameConfigViewModel = FileNameConfigViewModel()
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("新規ファイル名")
                Spacer()
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            Text("")
            VStack {
                HStack {
                    Text("現在のファイル名:\(self.viewModel.fileNameForDisplay)")
                    Spacer()
                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 10))
                HStack {
                    Spacer()
                    Button("変更") {

                        self.viewModel.openFileNameConfigModal()
                    }
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))

            }
        }.frame(width: 260, height: 95).mask(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1))
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}
