//
//  HomePageModel.swift
//  up-english
//
//  Created by James Tsai on 11/20/22.
//

import Foundation

@available(iOS 15, *)
class ArticleOpenerModel: ObservableObject {
    var handler: ArticleOpenerModelHandler?
    
    @Published var url: String
    @Published var fullText: String? {
        didSet {
            if let fullText {
                if let handler {
                    handler.readNewArticle(url: self.url, fullText: fullText)
                }
            }
        }
    }
    @Published var showFullTextView = false
    
    var lastSelectedRange: NSRange? {
        didSet {
            print(lastSelectedRange!.location, lastSelectedRange!.location + lastSelectedRange!.length)
            if let lastSelectedRange {
                if let handler {
                    handler.addLookup(range: lastSelectedRange)
                }
            }
        }
    }
    
    init(url: String) {
        self.url = url
    }
}

@available(iOS 15, *)
extension ArticleOpenerModel: Hashable {
    static func == (lhs: ArticleOpenerModel, rhs: ArticleOpenerModel) -> Bool {
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        hasher.combine(fullText)
        hasher.combine(showFullTextView)
    }
}

@available(iOS 15, *)
class ArticleOpenerModelHandler {
    private var articleReadingService: ArticleReadingService
    private var article: Article?
    init(articleReadingService: ArticleReadingService) {
        self.articleReadingService = articleReadingService
    }
    func readNewArticle(url: String, fullText: String) {
        self.article = try? self.articleReadingService.readNewArticle(url: url, fullText: fullText)
        if let article {
            article.sync()
        }
    }
    func addLookup(range: NSRange) {
        if let article {
            let selection = article.addSelection(range: Range(range, in: article.fullText)!)
            selection.sync()
        }
    }

}
