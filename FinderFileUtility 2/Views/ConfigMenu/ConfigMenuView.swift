import SwiftUI
import FinderSync

struct ConfigMenuView: View {
    var body: some View {
        HStack {
            VStack {
                PermissionSettings()
                FileNameConfig()
            }
            EditFileExtensionView()
        }
    }
}

#Preview {
    ConfigMenuView()
}
