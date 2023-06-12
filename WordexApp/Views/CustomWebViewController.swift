//
//  CustomWebViewController.swift
//  up-english
//
//  Created by James Tsai on 12/3/22.
//

import UIKit
import WebKit
import SwiftUI

class CustomWebViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {
    
    var url: Binding<String?>
    
    var webView = CustomEditMenuWKWebView(frame: UIScreen.main.bounds)
    
    var backButton: UIBarButtonItem?
    
    var forwardButton: UIBarButtonItem?
        
    var fullText: Binding<String?>
    
    var readerModeHTMLString: Binding<String?>
    
    var wordSelection: Binding<String?>
    
    init(url: Binding<String?>, fullText: Binding<String?>, readerModeHTMLString: Binding<String?>, wordSelection: Binding<String?>) {
        self.url = url
        self.fullText = fullText
        self.readerModeHTMLString = readerModeHTMLString
        self.wordSelection = wordSelection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = webView
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let readability = try! String.init(contentsOf: Bundle.main.url(forResource: "Readability", withExtension: "js")!)
        let processArticle = try! String.init(contentsOf: Bundle.main.url(forResource: "processArticle", withExtension: "js")!)
        let readabilityScript = WKUserScript(source: readability, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        let processArticleScript = WKUserScript(source: processArticle, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(readabilityScript)
        webView.configuration.userContentController.addUserScript(processArticleScript)
        webView.configuration.userContentController.add(self, name: "htmlHandler")
        
        if let urlToLoad = url.wrappedValue {
            if let url = URL(string: urlToLoad) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
        
        addCustomEditMenu()
                
        let refresh = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(image: UIImage(systemName: "chevron.forward"), style: .plain, target: webView, action: #selector(webView.goForward))
        let home = UIBarButtonItem(image: UIImage(systemName: "house"), style: .plain, target: webView, action: #selector(webView.goHome))
        back.isEnabled = false
        forward.isEnabled = false
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 60))
        toolBar.isTranslucent = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.items = [back, forward, home, refresh]
        webView.addSubview(toolBar)
        toolBar.bottomAnchor.constraint(equalTo: webView.bottomAnchor, constant: 0).isActive = true
        toolBar.leadingAnchor.constraint(equalTo: webView.leadingAnchor, constant: 0).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: webView.trailingAnchor, constant: 0).isActive = true
        self.backButton = back
        self.forwardButton = forward
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.webView.configuration.userContentController.removeAllScriptMessageHandlers()
    }
    
    func webView(_ webView: WKWebView, didCommit: WKNavigation!) {
        self.url.wrappedValue = webView.url?.absoluteString
        
        // determine forward and back button availability
        if !webView.canGoBack {
            self.backButton?.isEnabled = false
        } else {
            self.backButton?.isEnabled = true
        }
        if !webView.canGoForward {
            self.forwardButton?.isEnabled = false
        } else {
            self.forwardButton?.isEnabled = true
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let dictionary = message.body as? [String: String] else {return}
        guard let newHTMLString = dictionary["newHTMLString"] else {return}
        guard let fullText = dictionary["fullText"] else {return}
        
        self.readerModeHTMLString.wrappedValue = newHTMLString
        self.fullText.wrappedValue = fullText
    }
    
    func addCustomEditMenu() {
        let lookup = UIMenuItem(title: "Look up", action: #selector(lookup))
        let copyAndMark = UIMenuItem(title: "Copy & mark", action: #selector(copyAndMark))
        UIMenuController.shared.menuItems = [lookup, copyAndMark]
        UIMenuController.shared.update()
    }
    
    @objc func lookup() {
        webView.evaluateJavaScript("window.getSelection().toString()") { (text, error) in
            guard let text = text as? String, error == nil else {return}
            let dictionaryViewController = UIReferenceLibraryViewController(term: text)
            self.wordSelection.wrappedValue = text
            self.present(dictionaryViewController, animated: true)
        }
    }
    
    @objc func copyAndMark() {
        webView.evaluateJavaScript("window.getSelection().toString()") { (text, error) in
            guard let text = text as? String, error == nil else {return}
            self.wordSelection.wrappedValue = text
            UIPasteboard.general.string = text
        }
    }
}

