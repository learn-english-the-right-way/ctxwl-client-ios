//
//  HomeModelHandlerFake.swift
//  up-english
//
//  Created by James Tsai on 1/6/23.
//

import Foundation

@available(iOS 16.0, *)
class HomeModelHandlerFake: HomeModelHandler {
    var count = 0
    weak var model: HomeModel?
    init(model: HomeModel) {
        self.model = model
    }
    func refresh() {
        self.model?.articleItems.append(contentsOf: [
            ArticleListItem(url: "https://www.theverge.com/23521184/kaleidoscope-review-netflix-series-giancarlo-esposito", title: "0", summary: "this is summary"),
            ArticleListItem(url: "https://www.theverge.com/23527936/sony-alpha-a7rv-mirrorless-fullframe-camera-hands-on-ergonomics-pain", title: "0", summary: "this is summary"),
            ArticleListItem(url: "https://www.theverge.com/23513418/bring-back-personal-blogging", title: "0", summary: "this is summary"),
            ArticleListItem(url: "https://www.theverge.com/23521184/kaleidoscope-review-netflix-series-giancarlo-esposito", title: "0", summary: "this is summary"),
            ArticleListItem(url: "https://www.theverge.com/23527936/sony-alpha-a7rv-mirrorless-fullframe-camera-hands-on-ergonomics-pain", title: "0", summary: "this is summary"),
            ArticleListItem(url: "https://www.theverge.com/23513418/bring-back-personal-blogging", title: "0", summary: "this is summary"),
            ArticleListItem(url: "https://www.theverge.com/23521184/kaleidoscope-review-netflix-series-giancarlo-esposito", title: "0", summary: "this is summary"),
            ArticleListItem(url: "https://www.theverge.com/23527936/sony-alpha-a7rv-mirrorless-fullframe-camera-hands-on-ergonomics-pain", title: "0", summary: "this is summary"),
            ArticleListItem(url: "https://www.theverge.com/23513418/bring-back-personal-blogging", title: "0", summary: "this is summary"),
            ArticleListItem(url: "https://www.theverge.com/23521184/kaleidoscope-review-netflix-series-giancarlo-esposito", title: "0", summary: "this is summary"),
            ArticleListItem(url: "https://www.theverge.com/23527936/sony-alpha-a7rv-mirrorless-fullframe-camera-hands-on-ergonomics-pain", title: "0", summary: "this is summary"),
            ArticleListItem(url: "https://www.theverge.com/23513418/bring-back-personal-blogging", title: "0", summary: "this is summary")
        ])
    }
    
    func loadMore() {
        if model?.loading != true {
            model?.loading = true
            _ = Task {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                DispatchQueue.main.async {
                    self.model?.articleItems.append(contentsOf: [
                        ArticleListItem(url: "https://www.theverge.com/23521184/kaleidoscope-review-netflix-series-giancarlo-esposito", title: "\(self.count+1)", summary: "this is summary"),
                        ArticleListItem(url: "https://www.theverge.com/23527936/sony-alpha-a7rv-mirrorless-fullframe-camera-hands-on-ergonomics-pain", title: "\(self.count+2)", summary: "this is summary"),
                        ArticleListItem(url: "https://www.theverge.com/23513418/bring-back-personal-blogging", title: "\(self.count+3)", summary: "this is summary")
                    ])
                    self.count += 3
                    self.model?.loading = false
                }
            }
        }
    }
}
