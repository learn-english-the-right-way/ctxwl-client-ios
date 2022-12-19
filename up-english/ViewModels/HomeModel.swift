//
//  HomeModel.swift
//  up-english
//
//  Created by James Tsai on 12/11/22.
//

import Foundation

@available(iOS 16.0, *)
class HomeModel: ObservableObject {
    @Published var url: String = ""
    var handler: HomeModelHandler?
    func openArticle() {
        if let handler {
            handler.openArticle(url: self.url)
        }
    }
}

@available(iOS 16.0, *)
extension HomeModel: Hashable {
    static func == (lhs: HomeModel, rhs: HomeModel) -> Bool {
        if let lhsHandler = lhs.handler, let rhsHandler = rhs.handler {
            if lhs.url == rhs.url && ObjectIdentifier(lhsHandler) == ObjectIdentifier(rhsHandler) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }

    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}

@available(iOS 16.0, *)
class HomeModelHandler {
    var router: Router
    init(router: Router) {
        self.router = router
    }
    func openArticle(url: String) {
        var pageInfo = PageInfo(page: .ArticleOpener)
        pageInfo.articleOpenerPageContent = ArticleOpenerPageContent(url: url)
        self.router.append(page: pageInfo)
    }
}
