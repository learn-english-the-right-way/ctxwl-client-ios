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
}

@available(iOS 16.0, *)
class HomeModel: ObservableObject {
    @Published var articleItems: [ArticleListItem]
    
    init() {
        self.articleItems = [
            ArticleListItem(url: "https://www.theverge.com/23521184/kaleidoscope-review-netflix-series-giancarlo-esposito", title: "Kaleidoscope is a generic heist story but a fascinating experiment"),
            ArticleListItem(url: "https://www.theverge.com/23527936/sony-alpha-a7rv-mirrorless-fullframe-camera-hands-on-ergonomics-pain", title: "Sony’s A7R V camera is a technical triumph, so why is using it such a pain?"),
            ArticleListItem(url: "https://www.theverge.com/23513418/bring-back-personal-blogging", title: "Bring back personal blogging")
        ]
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
