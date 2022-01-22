//
//  ArticleListServiceDefault.swift
//  up-english
//
//  Created by Chen Zhao on 1/15/22.
//

import Foundation
import Combine

// Response Interface regarding each element from backend
//struct ArticleListItemResponse: Codable {
//    var title: String
//    var brief: String
//    var url: String
//}

class ArticleListServiceDefault: ArticleListService {

    func refresh() -> AnyPublisher<ArticleListItemResponse, Never> {
        let url = ApiUrl.loadUrl()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return URLSession(configuration: .default).dataTaskPublisher(for: request)
            .map { dataAndResponse in
                dataAndResponse.data
            }
            .decode(type: ArticleListItemResponse.self, decoder: JSONDecoder())
            .assertNoFailure()
            .eraseToAnyPublisher()
    }
    
    func loadMore() -> AnyPublisher<ArticleListItemResponse, Never> {
        let url = ApiUrl.loadUrl()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return URLSession(configuration: .default).dataTaskPublisher(for: request)
            .map { dataAndResponse in
                dataAndResponse.data
            }
            .decode(type: ArticleListItemResponse.self, decoder: JSONDecoder())
            .assertNoFailure()
            .eraseToAnyPublisher()
    }
}


