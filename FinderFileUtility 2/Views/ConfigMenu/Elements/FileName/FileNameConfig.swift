//
//  FileNameView.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/04/24.
//

import Foundation
import SwiftUI
struct FileNameConfig:View{
    @State var viewModel:FileNameConfigViewModel = FileNameConfigViewModel()
    var body: some View{
        VStack(spacing:4){
            Text("新規ファイルの名称")
            HStack{
                TextField("ファイル名を入力...",text: $viewModel.fileNameForDisplay)
                Button("変更") {
                    viewModel.updateDefaultFileNameData(fileName: viewModel.fileNameForDisplay)
                }.disabled(viewModel.fileNameForDisplay == viewModel.beforeEditingFileName)
                Button("戻す") {
                    viewModel.resetFileNameForDisplay()
                }.disabled(viewModel.fileNameForDisplay == viewModel.beforeEditingFileName)
            }
        }.frame(width:260,height:135).mask(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10)
                   .stroke(lineWidth: 1))
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}
