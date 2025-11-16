//
//  FinderSettingsViewParts.swift
//  FinderFileUtility 2
//
//  Created by ShowyaTanaka on 2025/04/24.
//
import SwiftUI
import FinderSync

struct PermissionSettings:View {
    @State var viewModel = ConfigMenuViewModel()
    var body: some View{
        VStack(spacing: 0){
            
            VStack{
            HStack{
                Text("Finder拡張")
                Spacer()
            }.padding(EdgeInsets(top:0,leading: 10,bottom: 0,trailing: 0))
            HStack{
                Spacer()
                if (viewModel.isEnableFinderExtension){
                    Text("許可済み")
                }
                else{
                    Button("許可する"){
                        FIFinderSyncController.showExtensionManagementInterface()
                    }
                }
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
        }
            Divider()
            VStack{
                HStack{
                    Text("ホームディレクトリへのアクセス")
                    Spacer()
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                HStack{
                    Spacer()
                    if viewModel.allowedDirectory != nil {
                        Text("許可済み")
                    }
                    else{
                        Button("許可する"){
                            Task {
                                await viewModel.saveSecureBookMark()
                            }
                        }
                    }
                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
            }
        }.frame(width:260,height:125).mask(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10)
                   .stroke(lineWidth: 1))
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}
