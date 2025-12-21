import Foundation

class DistributedNotificationHandler {
    private var observer: NSObjectProtocol?
    private weak var delegate: DistributedNotificationHandlerDelegate?
    func start() {
        guard let delegate = self.delegate else { return }
        self.observer = DistributedNotificationCenter.default().addObserver(
            forName: Notification.Name(delegate.notificationKey),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            Task {
                await delegate.callBack()
            }
            print("JAJSJSJ")
        }
    }
    func stop() {
        if let observer {
            DistributedNotificationCenter.default().removeObserver(observer)
            self.observer = nil
        }
    }

    init(delegate: DistributedNotificationHandlerDelegate) {
        self.delegate = delegate
        self.start()
    }
    deinit {
        self.stop()
    }
}
