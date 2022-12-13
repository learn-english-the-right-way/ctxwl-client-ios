//
//  ArticleReadingService.swift
//  up-english
//
//  Created by James Tsai on 12/4/22.
//

import Foundation

protocol ArticleReadingService {
    func readNewArticle(url: String, fullText: String) -> Void
    func addLookup(range: NSRange) -> Void
    func finishReading() -> Void
}
