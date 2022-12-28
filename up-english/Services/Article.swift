//
//  Article.swift
//  up-english
//
//  Created by James Tsai on 12/25/22.
//

import Foundation
import Combine

@available(iOS 15, *)
class Article {
    
    @available(iOS 15, *)
    struct ReadingEntryRequest: Encodable {
        var session: String
        var serial: Int
        var uri: String
        var text: String
        var creationTime: String = Date.now.ISO8601Format()
    }
    
    class SelectionHolder {
        weak var weakSelection: Selection?
        var strongSelection: Selection?
        init(selection: Selection) {
            self.strongSelection = selection
        }
    }
    
    var session: String
    var entrySerial: Int
    var currentLookupSerial = 0
    var url: String
    var fullText: String
    var selectedWords: [Int: SelectionHolder] = [:]
    weak var articleReadingService: ArticleReadingService?
    private var articleSyncingCancellable: AnyCancellable?
    
    init(session: String, serial: Int, url: String, fullText: String, articleReadingService: ArticleReadingService) {
        self.session = session
        self.entrySerial = serial
        self.url = url
        self.fullText = fullText
        self.articleReadingService = articleReadingService
    }
    
    deinit {
        print("article deinit")
        self.articleReadingService?.removeArticleHolder(key: self.entrySerial)
    }
    
    func addSelection(range: Range<String.Index>) -> Selection {
        let newSelectionSerial = currentLookupSerial + 1
        let newSelection = Selection(article: self, session: self.session, lookupSerial: newSelectionSerial, range: range)
        let newSelectionHolder = SelectionHolder(selection: newSelection)
        self.selectedWords.updateValue(newSelectionHolder, forKey: newSelectionSerial)
        self.currentLookupSerial += 1
        return newSelection
    }

    func sync() {
        let url = ApiUrl.readingEntryUrl(applicationKey: self.articleReadingService!.applicationKey!, session: self.session, serial: String(self.entrySerial))
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        let dataObject = ReadingEntryRequest(session: self.session, serial: self.entrySerial, uri: self.url, text: self.fullText)
        guard let data = try? JSONEncoder().encode(dataObject) else {
            print("failed to encode article object")
            return
        }
        request.httpBody = data
        self.articleSyncingCancellable = self.articleReadingService!.sessionProtectedDataTaskPublisher(request: request)
            .sink(receiveCompletion: {completion in
                switch completion {
                case .finished:
                    self.articleReadingService?.switchToWeakArticle(entrySerial: self.entrySerial)
                    self.articleSyncingCancellable = nil
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: {value in })
    }
    
    func removeSelectionHolder(key: Int) {
        self.selectedWords.removeValue(forKey: key)
    }
    
    func switchToWeakSelection(key: Int) {
        if var selectionHolder = self.selectedWords[key] {
            selectionHolder.weakSelection = selectionHolder.strongSelection
            selectionHolder.strongSelection = nil
        }
    }
    
}
