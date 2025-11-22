import SwiftUI
import Foundation
import Combine

struct EditFileExtensionView: View{
    @StateObject var viewModel = EditFileExtensionViewModel()
    @State var refreshExtensionList: Bool = false
    @State var selectedExtension: ExtensionName.ID?
    var body: some View {
        HStack {
            VStack {
                
                Table(self.viewModel.extensions, selection: $selectedExtension){
                    TableColumn("拡張子名") {extensionName in
                        Text(extensionName.extensionName)
                    }
                }    .tableStyle(.bordered)
                    .padding()
                HStack{
                    Button("拡張子を削除"){
                        if let selectedID = selectedExtension{
                            self.viewModel.deleteExtension(extensionID: selectedID)
                            selectedExtension = nil
                        }
                    }.disabled(selectedExtension == nil)
                    Button("拡張子を追加"){

                        DispatchQueue.main.async {
                            let modalViewModel = EditFileExtensionModalViewModel(editFileExtensionViewModel: self.viewModel)
                            let panelService = NSPanelManagementService(view: EditFileExtensionModalView(viewModel: modalViewModel), viewModel: modalViewModel)
                            panelService.openWindow(isfocused: true, title: "拡張子を追加", width: 300, height: 400)
                        }
                    }
                    }
                }
            }
        .frame(width:260,height:270).mask(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10)
                   .stroke(lineWidth: 1))
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
    }
