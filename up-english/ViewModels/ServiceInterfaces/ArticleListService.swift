////
////  ArticleListService.swift
////  up-english
////
////  Created by Chen Zhao on 1/15/22.
////
//
//import Foundation
//import Combine
//
//// Response Interface regarding each element from backend
//struct ArticleListItemResponse: Codable {
//    var title: String
//    var brief: String
//    var url: String
//}
//
//protocol ArticleListService: {
//    
//    func refresh() -> AnyPublisher<ArticleListItemResponse, Never>
//    
//    func loadMore() -> AnyPublisher<ArticleListItemResponse, Never>
//}
