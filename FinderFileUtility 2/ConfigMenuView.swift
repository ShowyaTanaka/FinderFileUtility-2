//
//  ConfigMenuView.swift
//  FinderFileUtility 2
//
//  Created by ShowyaTanaka on 2024/11/18.
//

import SwiftUI
import FinderSync

struct ConfigMenuView: View {
    var body: some View {
        HStack {
            VStack {
                PermissionSettings()
                FileName()
                Text(SecureBookMarkModel.getSecureBookMarkStringFullPath() ?? "none")
            }
        }
    }
}

#Preview {
    //ConfigMenuView()
}
