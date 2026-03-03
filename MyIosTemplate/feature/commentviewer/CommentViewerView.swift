import SwiftUI

struct CommentViewerView: View {
    @StateObject private var vm = CommentViewerViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 👇 接続状態表示
            Text(vm.wsStatus)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.vertical, 4)
            
            Divider()
            
            // 👇 コメント一覧
            List(vm.comments) { c in
                VStack(alignment: .leading, spacing: 4) {
                    Text(c.text)
                    Text(c.createdAt.formatted())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Comments")
        .toolbar {
            Button("Mock") { vm.addMock() }
            Button("Connect") { vm.connectWS() }
            Button("Disconnect") { vm.disconnectWS() }
        }
        .onAppear {
            if vm.comments.isEmpty {
                vm.addMock()
                vm.addMock()
            }
        }
    }
}
#Preview {
    NavigationView { CommentViewerView() }
}
