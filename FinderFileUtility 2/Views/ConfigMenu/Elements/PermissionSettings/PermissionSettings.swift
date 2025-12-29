import FinderSync
import SwiftUI

struct PermissionSettings: View {
    @State var viewModel = PermissionSettingsViewModel(userDefaultsModel: UserDefaultsModel(), nsAlertService: NSAlertService.self)
    var body: some View {
        VStack(spacing: 0) {
            permissionSettingsElementViewGenerator(
                title: "Finder拡張",
                condition: viewModel.isEnableFinderExtension,
                isConditionMatchedElement: Text("許可済み"),
                isConditionUnMatchedElement:
                    Button("許可する") {
                        FIFinderSyncController.showExtensionManagementInterface()
                    }
            )

            Divider()

            permissionSettingsElementViewGenerator(
                title: "ホームディレクトリへのアクセス",
                condition: viewModel.isAllowedDirectory,
                isConditionMatchedElement: Text("許可済み"),
                isConditionUnMatchedElement:
                    Button("許可する") {
                        Task {
                            viewModel.callSaveSecureBookMark()
                        }
                    }
            )

            Divider()

            permissionSettingsElementViewGenerator(
                title: "ログイン時自動起動: \(viewModel.isLaunchAtLoginEnabled() ? "有効" : "無効")",
                condition: viewModel.launchAtLogin != .enabled,
                isConditionMatchedElement:
                    Button("有効にする") {
                        Task {
                            viewModel.registerLogin()
                        }
                    },
                isConditionUnMatchedElement:
                    Button("無効にする") {
                        Task {
                            viewModel.unregisterLogin()
                        }
                    }
            )

        }.frame(width: 260, height: 165).mask(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1))
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}
