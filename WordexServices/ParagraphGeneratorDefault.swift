//
//  ArticleListServiceDefault.swift
//  up-english
//
//  Created by Chen Zhao on 1/15/22.
//

import Foundation
import Combine

public class ParagraphGeneratorServiceDefault: ParagraphGeneratorService {
    private var _paragraph = PassthroughSubject<ParagraphGeneratorResponse, Never>()
    
    
    private var sessionConnectionService: SessionConnectionService
    
    private var cancellable: AnyCancellable?
    
    public var paragraph: AnyPublisher<ParagraphGeneratorResponse, Never> {
        get {
            return _paragraph.share().eraseToAnyPublisher()
        }
    }
    
    public init(sessionConnectionService: SessionConnectionService) {
        self.sessionConnectionService = sessionConnectionService
    }

    public func refresh() {
        let url = ApiUrl.paragraphGeneratorURL()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        self.cancellable = self.sessionConnectionService.sessionProtectedDataTaskPublisher(request: request)
            .decode(type: ParagraphGeneratorResponse.self, decoder: JSONDecoder())
            .assertNoFailure()
            .sink(receiveValue: {value in
                self._paragraph.send(value)
            })
    }
}


