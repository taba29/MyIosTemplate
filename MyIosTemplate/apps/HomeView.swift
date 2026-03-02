import SwiftUI


struct HomeView: View {
    var body: some View {
        List {
            NavigationLink("コメント一覧") {
                CommentViewerView()
            }
            NavigationLink("設定（仮）") {
                Text("TODO: Settings")
            }
        }
        .navigationTitle("Home")
    }
}

#Preview {
    NavigationView { HomeView() }
}
