import Foundation
import Combine

final class CommentViewerViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var wsStatus: String = "DISCONNECTED"

    private let ws = WebSocketClient()
    private var cancellables = Set<AnyCancellable>()

    init() {
        // WebSocket受信 → commentsへ追加
        NotificationCenter.default.publisher(for: .wsDidReceiveText)
            .compactMap { $0.object as? String }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.comments.insert(Comment(text: text), at: 0)
            }
            .store(in: &cancellables)

        // 状態表示（CONNECTED / DISCONNECTED）
        ws.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ok in
                self?.wsStatus = ok ? "CONNECTED" : "DISCONNECTED"
            }
            .store(in: &cancellables)

        // エラー表示（あれば上書き）
        ws.$lastError
            .compactMap { $0 } // nilは無視
            .receive(on: DispatchQueue.main)
            .sink { [weak self] err in
                self?.wsStatus = "ERROR: \(err)"
            }
            .store(in: &cancellables)
    }

    func addMock() {
        comments.insert(Comment(text: "こんにちは \(comments.count + 1)"), at: 0)
    }

    func connectWS() {
        guard let url = URL(string: "ws://127.0.0.1:8080") else { return }
        ws.connect(url: url)
    }

    func disconnectWS() {
        ws.disconnect()
    }
}
