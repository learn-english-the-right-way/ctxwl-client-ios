//
//  Selection.swift
//  up-english
//
//  Created by James Tsai on 12/25/22.
//

import Foundation
import Combine

@available(iOS 15, *)
public class Selection {
    
    struct ReadingLookupRequest: Encodable {
        var session: String
        var entrySerial: Int
        var serial: Int
        var criterion: String
        var offset: Int?
        var creationTime: String = Date.now.ISO8601Format()
    }
    
    var session: String
    var entrySerial: Int
    var lookupSerial: Int
    var fullText: String
    var criterion: String
    var offset: Int?
    var syncCancellable: AnyCancellable?
    weak var sessionConnectionService: SessionConnectionService?
    weak var article: Article?
    
    init(article: Article, session: String, lookupSerial: Int, range: Range<String.Index>) {
        self.article = article
        self.fullText = article.fullText
        self.entrySerial = article.entrySerial
        self.lookupSerial = lookupSerial
        self.session = session
        self.criterion = String(fullText[range])
        self.offset = range.lowerBound.utf16Offset(in: fullText)
        self.sessionConnectionService = article.articleReadingService
    }
    
    init(article: Article, session: String, lookupSerial: Int, text: String) {
        self.article = article
        self.fullText = article.fullText
        self.entrySerial = article.entrySerial
        self.lookupSerial = lookupSerial
        self.session = session
        self.criterion = text
        self.sessionConnectionService = article.articleReadingService
    }
    
    deinit {
        print("selection deinit")
        if let article = self.article {
            article.removeSelectionHolder(key: lookupSerial)
        }
    }
    
    public func sync() {
        let url = ApiUrl.readingLookupUrl(session: self.session, entrySerial: self.entrySerial, lookupSerial: self.lookupSerial)
        var request = URLRequest(url: url)
        let dataObject = ReadingLookupRequest(session: session, entrySerial: entrySerial, serial: lookupSerial, criterion: criterion, offset: offset)
        print(dataObject)
        guard let data = try? JSONEncoder().encode(dataObject) else {
            print("failed to encode article lookup")
            return
        }
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        self.syncCancellable = self.sessionConnectionService!.sessionProtectedDataTaskPublisher(request: request)
            .sink(receiveCompletion: {completion in
                switch completion {
                case .finished:
                    self.article?.switchToWeakSelection(key: self.lookupSerial)
                    self.syncCancellable = nil
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: {value in})
    }
}
