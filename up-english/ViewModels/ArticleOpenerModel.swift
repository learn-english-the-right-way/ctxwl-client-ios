//
//  HomePageModel.swift
//  up-english
//
//  Created by James Tsai on 11/20/22.
//

import Foundation

class ArticleOpenerModel: ObservableObject {
    var handler: ArticleOpenerModelHandler?
    
    @Published var url: String
    @Published var fullText: String? {
        didSet {
            if let fullText {
                showFullText = true
                if let handler {
                    handler.readNewArticle(url: self.url, fullText: fullText)
                }
            }
        }
    }
    @Published var showFullText = false
    
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
    
    func finishReading() {
        self.handler?.finishReading()
    }
}

extension ArticleOpenerModel: Hashable {
    static func == (lhs: ArticleOpenerModel, rhs: ArticleOpenerModel) -> Bool {
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        hasher.combine(fullText)
        hasher.combine(showFullText)
    }
}

class ArticleOpenerModelHandler {
    private var articleReadingService: ArticleReadingService
    init(articleReadingService: ArticleReadingService) {
        self.articleReadingService = articleReadingService
    }
    func readNewArticle(url: String, fullText: String) {
        self.articleReadingService.readNewArticle(url: url, fullText: fullText)
    }
    func addLookup(range: NSRange) {
        self.articleReadingService.addLookup(range: range)
    }
    func finishReading() {
        self.articleReadingService.finishReading()
    }
}
