//
//  ActionExtensionReaderModeBrowserViewController.swift
//  wordex-action-extension
//
//  Created by James Cai on 3/11/23.
//

import Foundation
import UIKit
import WordexServices
import WebKit

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
    
    override func getRange() {
        webView.evaluateJavaScript(super.getRangeJS) { (value, error) in
            guard let value = value as? String else {return}
            let array = value.components(separatedBy: " ")
            guard let offset = Int(array[0]) else {return}
            guard let length = Int(array[1]) else {return}
            let range = NSRange(location: offset, length: length)
            let selection = self.article?.addSelection(range: Range(range, in: self.fullText!)!)
            selection?.sync()
        }
    }

    @objc override func lookup() {
        self.getRange()
        webView.evaluateJavaScript("window.getSelection().toString()") { (text, error) in
            guard let text = text as? String, error == nil else {return}
            let dictionaryViewController = UIReferenceLibraryViewController(term: text)
            self.present(dictionaryViewController, animated: true)
        }
    }

    @objc override func copyAndMark() {
        self.getRange()
        webView.evaluateJavaScript("window.getSelection().toString()") { (text, error) in
            guard let text = text as? String, error == nil else {return}
            UIPasteboard.general.string = text
        }
    }
}
