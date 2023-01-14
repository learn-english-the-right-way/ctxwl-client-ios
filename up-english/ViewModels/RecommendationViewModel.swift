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
class RecommendationViewModel: ObservableObject {
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
