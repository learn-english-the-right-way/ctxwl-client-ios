//
//  ReaderModeBrowserViewController.swift
//  up-english
//
//  Created by James Cai on 2/16/23.
//

import UIKit
import WebKit
import SwiftUI

class ReaderModeBrowserViewController: UIViewController, WKScriptMessageHandler {
    
    var selectionRange: Binding<NSRange?>?
    
    var webView = CustomEditMenuWKWebView(frame: UIScreen.main.bounds)
    
    var getRangeJS = try! String(contentsOf: Bundle.main.url(forResource: "getRange", withExtension: "js")!)
    var getLengthJS = try! String(contentsOf: Bundle.main.url(forResource: "getLength", withExtension: "js")!)

    override func loadView() {
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomEditMenu()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    }

    func addCustomEditMenu() {
        let lookup = UIMenuItem(title: "Look up", action: #selector(lookup))
        let copyAndMark = UIMenuItem(title: "Copy & mark", action: #selector(copyAndMark))
        UIMenuController.shared.menuItems = [lookup, copyAndMark]
        UIMenuController.shared.update()
    }
    
    @objc func lookup() {
        getRange()
        webView.evaluateJavaScript("window.getSelection().toString()") { (text, error) in
            guard let text = text as? String, error == nil else {return}
            let dictionaryViewController = UIReferenceLibraryViewController(term: text)
            self.present(dictionaryViewController, animated: true)
        }
    }
    
    @objc func copyAndMark() {
        getRange()
        webView.evaluateJavaScript("window.getSelection().toString()") { (text, error) in
            guard let text = text as? String, error == nil else {return}
            UIPasteboard.general.string = text
        }
    }
    
    func getRange() {
        webView.evaluateJavaScript(getRangeJS) { (value, error) in
            guard let value = value as? String else {return}
            let array = value.components(separatedBy: " ")
            guard let offset = Int(array[0]) else {return}
            guard let length = Int(array[1]) else {return}
            let range = NSRange(location: offset, length: length)
            self.selectionRange?.wrappedValue = range
        }
    }
}
