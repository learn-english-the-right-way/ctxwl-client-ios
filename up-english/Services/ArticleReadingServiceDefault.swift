//
//  ArticleReadingServiceDefault.swift
//  up-english
//
//  Created by James Tsai on 12/4/22.
//

import Foundation
import Combine

@available(iOS 15, *)
class ArticleReadingServiceDefault: ArticleReadingService {
    
    struct ReadingSessionDocument: Decodable {
        var session: String
        var updateTime: Int?
        var completionTime: Int?
        var terminationTime: Int?
    }
    
    @available(iOS 15, *)
    struct ReadingEntryRequest: Encodable {
        var session: String
        var serial: Int
        var uri: String
        var text: String
        var creationTime: String = Date.now.ISO8601Format()
    }
    
    struct ReadingLookupRequest: Encodable {
        var session: String
        var entrySerial: Int
        var criterion: String
        var offset: Int
    }
    
    class Article {
        class Selection {
            var article: Article
            var range: Range<String.Index>
            var synced: Bool = false
            var syncCancellable: AnyCancellable?
            init(article: Article, range: Range<String.Index>) {
                self.article = article
                self.range = range
            }
            func sync() {
                let url = ApiUrl.readingLookupUrl()
                var request = URLRequest(url: url)
                let criterion = String(article.fullText[range])
                let offset = range.lowerBound.utf16Offset(in: article.fullText)
                let dataObject = ReadingLookupRequest(session: article.session, entrySerial: article.serial, criterion: criterion, offset: offset)
                guard let data = try? JSONEncoder().encode(dataObject) else {
                    print("failed to encode article lookup")
                    return
                }
                request.httpMethod = "POST"
                request.httpBody = data
                self.syncCancellable = self.article.articleReadingService.sessionConnectionService.sessionProtectedDataTaskPublisher(request: request)
                    .sink(receiveCompletion: {completion in
                        switch completion {
                        case .finished:
                            self.synced = true
                            if self.article.isSynced() {
                                self.article.articleReadingService.removeArticle(serial: self.article.serial)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }, receiveValue: {value in})
            }
        }
        var session: String
        var serial: Int
        var url: String
        var fullText: String
        var selectedWords: [Selection] = []
        var articleSynced = false
        var articleReadingService: ArticleReadingServiceDefault
        private var articleSyncingCancellable: AnyCancellable?
        init(session: String, serial: Int, url: String, fullText: String, articleReadingService: ArticleReadingServiceDefault) {
            self.session = session
            self.serial = serial
            self.url = url
            self.fullText = fullText
            self.articleReadingService = articleReadingService
        }
        func addSelection(range: Range<String.Index>) {
            self.selectedWords.append(Selection(article: self, range: range))
        }
        
        func isSynced() -> Bool {
            if self.articleSynced == false {
                return false
            }
            for selection in selectedWords {
                if selection.synced == false {
                    return false
                }
            }
            return true
        }

        private func syncArticle() {
            let url = ApiUrl.readingEntryUrl(applicationKey: self.articleReadingService.sessionConnectionService.applicationKey!, session: self.session, serial: String(self.serial))
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PUT"
            let dataObject = ReadingEntryRequest(session: self.session, serial: self.serial, uri: self.url, text: self.fullText)
            guard let data = try? JSONEncoder().encode(dataObject) else {
                print("failed to encode article object")
                return
            }
            request.httpBody = data
            self.articleSyncingCancellable = self.articleReadingService.sessionConnectionService.sessionProtectedDataTaskPublisher(request: request)
                .sink(receiveCompletion: {completion in
                    switch completion {
                    case .finished:
                        self.articleSynced = true
                        if self.isSynced() {
                            self.articleReadingService.removeArticle(serial: self.serial)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }, receiveValue: {value in })
        }
        
        func sync() {
            // sync article
            self.syncArticle()
            //sync lookups
            for selectedWord in selectedWords {
                selectedWord.sync()
            }
        }
        
    }
    
    private var articleList: [Int: Article] = [:]
    
    private var currentSerial: Int = 0
    
    var sessionConnectionService: UserService
    
    private var session: String?
    
    private var getSessionRequestCancellable: AnyCancellable?
    
    init(sessionConnectionService: UserService) {
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
    
    private func getCurrentArticle() -> Article? {
        return articleList[currentSerial]
    }

    func readNewArticle(url: String, fullText: String) {
        if let session = self.session {
            let newSerial = currentSerial + 1
            let newArticle = Article(session: session, serial: newSerial, url: url, fullText: fullText, articleReadingService: self)
            self.articleList[newSerial] = newArticle
            self.currentSerial = newSerial
        }
    }
    
    func addLookup(range: NSRange) {
        guard let currentArticle = self.getCurrentArticle() else {
            return
        }
        guard let range = Range(range, in: currentArticle.fullText) else {
            return
        }
        currentArticle.addSelection(range: range)
    }
    
    func finishReading() {
        guard let currentArticle = self.getCurrentArticle() else {
            return
        }
        currentArticle.sync()
    }
    
    func removeArticle(serial: Int) {
        self.articleList.removeValue(forKey: serial)
    }
}
