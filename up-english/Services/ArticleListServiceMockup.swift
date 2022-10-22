////
////  ArticleListServiceMockup.swift
////  up-english
////
////  Created by Chen Zhao on 1/18/22.
////
//
//import Foundation
//import Combine
//import SwiftUI
//import Peppermint
//
//class ArticleListServiceMockup: ArticleListService {
//    private var counter: Int
//
//    init() { self.counter = 0 }
//
//    func refresh() -> AnyPublisher<ArticleListItemResponse, Never> {
//        self.counter = 0
//        let range = ((1 + 15 * self.counter)...15 * (self.counter + 1))
//        print("refresh \(self.counter)")
//        return range.publisher
//                       .map { index in
//                            ArticleListItemResponse(
//                                title: "\(index)",
//                                brief: "Wiki regarding \(index)",
//                                url: "https://en.wikipedia.org/wiki/\(index)")
//                       }.eraseToAnyPublisher()
//    }
//
//    func loadMore() -> AnyPublisher<ArticleListItemResponse, Never> {
//        self.counter += 1
//        let range = ((1 + 15 * self.counter)...15 * (self.counter + 1))
//        print("loadmore \(self.counter)")
//        return range.publisher
//                       .map { index in
//                            ArticleListItemResponse(
//                                title: "\(index)",
//                                brief: "Wiki regarding \(index)",
//                                url: "https://en.wikipedia.org/wiki/\(index)")
//                       }.eraseToAnyPublisher()
//    }
//}
