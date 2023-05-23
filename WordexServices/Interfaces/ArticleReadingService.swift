//
//  ArticleReadingService.swift
//  up-english
//
//  Created by James Tsai on 12/4/22.
//

import Foundation

@available(iOS 15, *)
public protocol ArticleReadingService: SessionConnectionService, AnyObject {
    func removeArticleHolder(key: Int) -> Void
    func switchToWeakArticle(entrySerial: Int) -> Void
    func readNewArticle(url: String, fullText: String) throws -> Article
}
