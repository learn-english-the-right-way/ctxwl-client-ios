//
//  ArticleListModelDefault.swift
//  up-english
//
//  Created by Chen Zhao on 1/15/22.
//

import Foundation
import Combine

struct ArticleListInfo: ArticleInfo {
    var title: String
    var brief: String
    var url: String
}

class ArticleListModelDefault<ArticleListServiceType>: ArticleListModel where ArticleListServiceType: ArticleListService {
    @Published var items: [ArticleListInfo]
    @Published var isLoading: Bool
    private var articleListService: ArticleListServiceType
    private var articleListCancellable: AnyCancellable?
    
    init(articleService: ArticleListServiceType) {
        self.isLoading = false
        self.items = []
        self.articleListService = articleService
        print("initialization start")
        self.articleListCancellable = refresher()
        print("initialization complete")
    }
    
    func refresher() -> AnyCancellable {
        return self.articleListService.refresh()
                                       .map { item in ArticleListInfo(title: item.title, brief: item.brief, url: item.url) }
                                       .sink(receiveCompletion: { completion in
                                           self.isLoading = false
                                       }, receiveValue: { item in
                                           self.isLoading = true
                                           self.items.append(item)
                                       })
    }
    
    func refresh() {
        self.items = []
        print("refresh start")
        self.articleListCancellable = refresher()
        print("refreshing complete")
    }
    
    func loadMore() {
        self.articleListCancellable = self.articleListService.loadMore()
            .map { item in ArticleListInfo(title: item.title, brief: item.brief, url: item.url) }
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                print("loadMore complete")
            }, receiveValue: { item in
                self.isLoading = true
                self.items.append(item)
                print("loadMore appending \(item.title)")
            })
    }
}