//
//  ActionExtensionReaderModeBrowserViewController.swift
//  wordex-action-extension
//
//  Created by James Cai on 3/11/23.
//

import Foundation
import UIKit
import WordexServices

class ActionExtensionReaderModeBrowserViewController: ReaderModeBrowserViewController {
    var service: ArticleReadingService?
    var fullText: String?
    var article: Article?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        do {
            self.article = try service?.readNewArticle(url: "", fullText: self.fullText ?? "")
            self.article?.sync()
        } catch {
            print(error)
        }
    }

    @objc override func lookup() {
        super.getRange()
        webView.evaluateJavaScript("window.getSelection().toString()") { (text, error) in
            guard let text = text as? String, error == nil else {return}
            let dictionaryViewController = UIReferenceLibraryViewController(term: text)
            self.present(dictionaryViewController, animated: true)
            let selection = self.article?.addSelection(text: text)
            selection?.sync()
        }
    }

    @objc override func copyAndMark() {
        super.getRange()
        webView.evaluateJavaScript("window.getSelection().toString()") { (text, error) in
            guard let text = text as? String, error == nil else {return}
            UIPasteboard.general.string = text
            let selection = self.article?.addSelection(text: text)
            selection?.sync()
        }
    }
}
