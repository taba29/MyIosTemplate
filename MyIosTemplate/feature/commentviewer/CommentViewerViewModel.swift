import Foundation
import Combine

final class CommentViewerViewModel: ObservableObject {
    @Published var comments: [Comment] = []

    func addMock() {
        comments.insert(Comment(text: "こんにちは \(comments.count + 1)"), at: 0)
    }
}
