//
//  EditFileNameView.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/09/21.
//
import SwiftUI

struct EditFileNameView: View {
    @StateObject var viewModel: EditFileNameViewModel
    init(viewModel: EditFileNameViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack {
            Text("ファイル名を入力してください。")
            TextField("ファイル名", text: self.$viewModel.fileName)
        }
    }
}
