📦 CommentViewer 母艦 v0.1
SwiftUI で構築された配信コメントビューアの iOS テンプレート。
ViewModel + ObservableObject + WebSocket によるリアルタイム更新の基本動作を確認済み。
✅ 現在の到達点（Phase 1）
SwiftUI List によるコメント一覧表示
CommentViewerViewModel（ObservableObject）
@StateObject による ViewModel ライフサイクル管理
@Published によるリアクティブ更新
Mock ボタンでコメントを追加
WebSocket 接続（ws://127.0.0.1:8080）確認済み
サーバからのメッセージ受信成功（hello from server 表示確認済み）
👉 Mock を押すとリストがリアルタイムで増える
👉 Connect を押すと WebSocket 経由でメッセージ受信
🧱 アーキテクチャ（現段階）
core/
 └─ network/
     └─ WebSocketClient.swift

feature/
 └─ commentviewer/
     ├─ CommentViewerView.swift
     └─ CommentViewerViewModel.swift
🔁 データフロー
WebSocket → WebSocketClient
           → ViewModel
           → SwiftUI List
🔧 ViewModel（抜粋）
final class CommentViewerViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var wsStatus: String = "DISCONNECTED"
}
🖥 View（抜粋）
@StateObject private var vm = CommentViewerViewModel()

.toolbar {
    Button("Mock") { vm.addMock() }
    Button("Connect") { vm.connectWS() }
    Button("Disconnect") { vm.disconnectWS() }
}
▶️ 動作確認手順
Node WebSocket サーバを起動
アプリ起動
Connect を押す
サーバメッセージが List に表示されることを確認
🧠 技術ポイント
import Combine が無いと ObservableObject は動作しない
@StateObject は struct 内に配置必須
iOSシミュレータでは 127.0.0.1 が Mac を指す
WebSocket は URLSessionWebSocketTask を使用