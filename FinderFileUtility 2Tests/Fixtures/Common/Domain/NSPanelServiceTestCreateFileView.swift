import Testing
@testable import FinderFileUtility_2

import SwiftUI

struct NSPanelServiceTestCreateFileView: View {
    @ObservedObject var viewModel: NSPanelServiceTestCreateFileViewModel
    
    init(viewModel: NSPanelServiceTestCreateFileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text("テスト")
        }
    }
}
