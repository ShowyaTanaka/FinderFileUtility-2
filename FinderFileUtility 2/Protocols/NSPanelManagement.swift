//
//  NSPanelManagement.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/11/09.
//
import SwiftUI
protocol NSPanelManagementView: View {
    associatedtype isCloseWindowStat: isCloseWindowStatus
    var isCloseWindow: isCloseWindowStat { get }
}
extension NSPanelManagementView {
    func closeWindow() {
        self.isCloseWindow.isClose = true
    }
}

class isCloseWindowStatus: ObservableObject {
    @Published var isClose: Bool = false
}
