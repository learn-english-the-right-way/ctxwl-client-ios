//
//  ArticleReadingServiceDefault.swift
//  up-english
//
//  Created by James Tsai on 12/4/22.
//

import Foundation
import Combine

@available(iOS 15, *)
class ArticleReadingServiceDefault: ArticleReadingService, SessionConnectionService {
    
    struct ReadingSessionDocument: Decodable {
        var session: String
        var updateTime: Int?
        var completionTime: Int?
        var terminationTime: Int?
    }
    
    class ArticleHolder {
        weak var weakArticle: Article?
        var strongArticle: Article?
        init(article: Article) {
            self.strongArticle = article
        }
    }
    
    private var articleList: [Int: ArticleHolder] = [:]
    
    private var currentSerial: Int = 0
    
    private var sessionConnectionService: SessionConnectionService
    
    private var session: String?
    
    private var getSessionRequestCancellable: AnyCancellable?
    
    var loggedIn: AnyPublisher<Bool, Never> {
        return self.sessionConnectionService.loggedIn
    }
    
    init(sessionConnectionService: SessionConnectionService) {
        self.sessionConnectionService = sessionConnectionService
        var request = URLRequest(url: ApiUrl.readingSessionUrl())
        request.httpMethod = "POST"
        self.getSessionRequestCancellable = self.sessionConnectionService.authenticationKeyAccquired
            .flatMap { key in
                self.sessionConnectionService.sessionProtectedDataTaskPublisher(request: request)
            }
            .map { response in
                print(response)
                return response
            }
            .decode(type: ReadingSessionDocument.self, decoder: JSONDecoder())
            .map { response in response.session }
            .sink(receiveCompletion: {completion in
                print(completion)
            }, receiveValue: {value in
                self.session = value
            })
    }

    func readNewArticle(url: String, fullText: String) throws -> Article {
        if let session = self.session {
            let newSerial = currentSerial + 1
            let newArticle = Article(session: session, serial: newSerial, url: url, fullText: fullText, articleReadingService: self)
            self.articleList.updateValue(ArticleHolder(article: newArticle), forKey: newSerial)
            self.currentSerial = newSerial
            return newArticle
        } else {
            throw READING_SESSION_MISSING()
        }
    }
    
    func removeArticleHolder(key: Int) {
        self.articleList.removeValue(forKey: key)
    }
    
    func switchToWeakArticle(entrySerial: Int) {
        if let articleHolder = self.articleList[entrySerial] {
            articleHolder.weakArticle = articleHolder.strongArticle
            articleHolder.strongArticle = nil
        }
    }
    
    var applicationKey: String? {
        get {
            return self.sessionConnectionService.applicationKey
        }
    }
    
    var authenticationKeyAccquired: AnyPublisher<String, Never> {
        get {
            return self.sessionConnectionService.authenticationKeyAccquired
        }
    }
    
    func sessionProtectedDataTaskPublisher(request: URLRequest) -> AnyPublisher<Data, CLIENT_ERROR> {
        return self.sessionConnectionService.sessionProtectedDataTaskPublisher(request: request)
    }

}
