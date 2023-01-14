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
    
    var webView: WKWebView = WKWebView(frame: UIScreen.main.bounds)
        
    var fullText: Binding<String?>
    
    init(url: Binding<String?>, fullText: Binding<String?>) {
        self.url = url
        self.fullText = fullText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
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
        
        self.view = webView
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true

        let script = WKUserScript(source: scriptToExtractRawText, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(script)
        webView.configuration.userContentController.add(self, name: "htmlHandler")
        
        if let urlToLoad = url.wrappedValue {
            if let url = URL(string: urlToLoad) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
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
    
}
