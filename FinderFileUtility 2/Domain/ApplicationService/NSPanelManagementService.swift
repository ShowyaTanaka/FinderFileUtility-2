import Combine
class NSPanelManagementService<Content: NSPanelManagementView, VMContent: NSPanelManagementViewModelProtocol>:ObservableObject {
    var nsPanel = ControlledNSPanel()
    var view: Content
    private var cancellables = Set<AnyCancellable>()

    
    init(view: Content, viewModel: VMContent) {
        self.view = view
        viewModel.isWindowClosePublisher.sink { recieveComplete in

        } receiveValue: { [weak self] isCloseWindow in
            print("HHHHH")
            guard let self = self else { return }
            if isCloseWindow{
                self.closeWindow()
            }
        }.store(in: &cancellables)
    }
    
    func closeWindow() {
        self.nsPanel.close()
    }
    
    func openWindow(isfocused: Bool = false, title: String, x: Int=600, y: Int=400, width: Int=300, height: Int=200){
        self.nsPanel.open(view: self.view, isfocused: isfocused, title: title, x: x, y: y, width: width, height: height)
    }
}
