//
//  HomeModel.swift
//  up-english
//
//  Created by James Tsai on 12/11/22.
//

import Foundation

struct ArticleListItem: Hashable, Identifiable {
    var id = UUID()
    var url: String
    var title: String
    var summary: String
}

protocol HomeModelHandler: AnyObject {
    func loadMore() -> Void
    func refresh() -> Void
}

@available(iOS 16.0, *)
class HomeModel: ObservableObject {
    @Published var articleItems: [ArticleListItem] = []
    var loading = false
    var handler: HomeModelHandler?
    
    func shouldLoadAfter(item: ArticleListItem) -> Bool {
        if let lastItemID = self.articleItems.last?.id {
            if item.id == lastItemID {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func loadMore() {
        self.handler?.loadMore()
    }
    func refresh() {
        self.handler?.refresh()
    }
}


//@available(iOS 16.0, *)
//extension HomeModel: Hashable {
//    static func == (lhs: HomeModel, rhs: HomeModel) -> Bool {
//        if let lhsHandler = lhs.handler, let rhsHandler = rhs.handler {
//            if lhs.url == rhs.url && ObjectIdentifier(lhsHandler) == ObjectIdentifier(rhsHandler) {
//                return true
//            } else {
//                return false
//            }
//        } else {
//            return false
//        }
//
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(url)
//    }
//}
//
//@available(iOS 16.0, *)
//class HomeModelHandler {
//
//    func openArticle(url: String) {
//        var pageInfo = PageInfo(page: .ArticleOpener)
//        pageInfo.articleOpenerPageContent = ArticleOpenerPageContent(url: url)
//        self.router.append(page: pageInfo)
//    }
//}
