//
//  ConfigMenuView.swift
//  FinderFileUtility 2
//
//  Created by ShowyaTanaka on 2024/11/18.
//

import SwiftUI

struct ConfigMenuView: View {
    @State var viewModel = ConfigMenuViewModel()
    var body: some View {
        HStack {
            VStack {
                if !viewModel.isEnableFinderExtension {
                    Text("Finder拡張は許可されていません。以下のボタンを押して許可してください。")
                }
                else {
                    Text("Finder拡張は許可されています")
                }
                if let directory = viewModel.allowedDirectory {
                    Text("ディレクトリ操作が許可されています。ディレクトリ:\(directory)")
                }
                else {
                    Text("ディレクトリ操作が許可されていません。次のボタンを押して許可してください。")
                    Button(action: {
                        Task {
                            await viewModel.saveSecureBookMark()
                        }
                    }, label: {
                        Text("Test")
                    })
                }

            }
            .padding()
            
        }
    }
}

#Preview {
    ConfigMenuView()
}
