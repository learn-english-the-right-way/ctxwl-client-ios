//
//  ArticleListServiceDefault.swift
//  up-english
//
//  Created by Chen Zhao on 1/15/22.
//

import Foundation
import Combine

class ArticleListServiceDefault: ArticleListService {
    
    private var ctxwlUrlSession: CTXWLURLSession
    
    init(ctxwlUrlSession: CTXWLURLSession) {
        self.ctxwlUrlSession = ctxwlUrlSession
    }

    func refresh() -> AnyPublisher<ArticleListItemResponse, Never> {
        let url = ApiUrl.loadUrl()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return self.ctxwlUrlSession.dataTaskPublisher(for: request)
            .decode(type: ArticleListItemResponse.self, decoder: JSONDecoder())
            .assertNoFailure()
            .eraseToAnyPublisher()
    }
    
    func loadMore() -> AnyPublisher<ArticleListItemResponse, Never> {
        let url = ApiUrl.loadUrl()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return self.ctxwlUrlSession.dataTaskPublisher(for: request)
            .decode(type: ArticleListItemResponse.self, decoder: JSONDecoder())
            .assertNoFailure()
            .eraseToAnyPublisher()
    }
}


