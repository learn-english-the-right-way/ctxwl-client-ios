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
        
    var fullText: Binding<String?>
    
    var wordSelection: Binding<String?>
    
    init(url: Binding<String?>, fullText: Binding<String?>, wordSelection: Binding<String?>) {
        self.url = url
        self.fullText = fullText
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
        let mercuryPackage = try? String.init(contentsOf: Bundle.main.url(forResource: "mercury.web", withExtension: "js")!)
        
        let scriptToExtractRawText = """
                function parseText()
                {
                    var html = document.documentElement.outerHTML
                    var promisedText = (function() {
"""
        + mercuryPackage! + """
            ; return Mercury.parse(document.location.toString(), {html: html, contentType: "text"})})()
                    promisedText.then(result=>window.webkit.messageHandlers.htmlHandler.postMessage(result.content))
                }
                window.onload = parseText
            """
        let script = WKUserScript(source: scriptToExtractRawText, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(script)
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
        let home = UIBarButtonItem(image: UIImage(systemName: "house"), style: .plain, target: webView, action: #selector(webView.goHome))
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 60))
        toolBar.isTranslucent = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.items = [back, home, refresh]
        webView.addSubview(toolBar)
        toolBar.bottomAnchor.constraint(equalTo: webView.bottomAnchor, constant: 0).isActive = true
        toolBar.leadingAnchor.constraint(equalTo: webView.leadingAnchor, constant: 0).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: webView.trailingAnchor, constant: 0).isActive = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.webView.configuration.userContentController.removeAllScriptMessageHandlers()
    }
    
    func webView(_ webView: WKWebView, didCommit: WKNavigation!) {
        self.url.wrappedValue = webView.url?.absoluteString
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.fullText.wrappedValue = message.body as? String
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

