import Foundation
import Combine

final class WebSocketClient: ObservableObject {
    @Published var isConnected: Bool = false
    @Published var lastError: String? = nil

    private var task: URLSessionWebSocketTask?
    private let session = URLSession(configuration: .default)

    func connect(url: URL) {
        disconnect()

        let task = session.webSocketTask(with: url)
        self.task = task
        task.resume()

        // まだ成功確定じゃないので true にしない
        DispatchQueue.main.async {
            self.lastError = nil
            self.isConnected = false
        }

        receiveLoop()
    }

    func disconnect() {
        task?.cancel(with: .goingAway, reason: nil)
        task = nil
        DispatchQueue.main.async {
            self.isConnected = false
        }
    }

    func send(text: String) {
        guard let task else { return }
        task.send(.string(text)) { [weak self] error in
            if let error {
                DispatchQueue.main.async {
                    self?.lastError = error.localizedDescription
                }
            }
        }
    }

    private func receiveLoop() {
        guard let task else { return }

        task.receive { [weak self] result in
            guard let self else { return }

            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.lastError = error.localizedDescription
                    self.isConnected = false
                }

            case .success(let message):
                // 受信できた = ちゃんと繋がってる扱いにする
                DispatchQueue.main.async {
                    self.lastError = nil
                    self.isConnected = true
                }

                switch message {
                case .string(let text):
                    NotificationCenter.default.post(name: .wsDidReceiveText, object: text)

                case .data(let data):
                    let text = String(data: data, encoding: .utf8) ?? "(binary \(data.count) bytes)"
                    NotificationCenter.default.post(name: .wsDidReceiveText, object: text)

                @unknown default:
                    break
                }

                // 次も受信し続ける
                self.receiveLoop()
            }
        }
    }
}

extension Notification.Name {
    static let wsDidReceiveText = Notification.Name("wsDidReceiveText")
}
