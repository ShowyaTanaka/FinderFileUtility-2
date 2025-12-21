import ServiceManagement
import SwiftUI

@main
struct FinderFileUtility_2App: App {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openWindow) private var openWindow
    var body: some Scene {
        WindowGroup(id: "ConfigWindow") {
            ConfigMenuView()
        }
    }

}
