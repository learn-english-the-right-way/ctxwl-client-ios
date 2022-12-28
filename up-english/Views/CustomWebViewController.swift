//
//  CustomWebViewController.swift
//  up-english
//
//  Created by James Tsai on 12/3/22.
//

import UIKit
import WebKit

protocol CustomWebViewControllerDelegate {
    func passRawtext(_ text: String) -> Void
}

class CustomWebViewController: UIViewController, WKScriptMessageHandler {
    
    var urlString: String?
    
    var webView: WKWebView = WKWebView(frame: UIScreen.main.bounds)
    
    var delegate: CustomWebViewControllerDelegate?
    
    var fullHTML: String?
    
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

        let script = WKUserScript(source: scriptToExtractRawText, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(script)
        webView.configuration.userContentController.add(self, name: "htmlHandler")
        
        if let urlToLoad = urlString {
            if let url = URL(string: urlToLoad) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.webView.configuration.userContentController.removeAllScriptMessageHandlers()
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let mercuryPackage = try? String.init(contentsOf: Bundle.main.url(forResource: "mercury.web", withExtension: "js")!)
//
//        let scriptToExtractRawText = """
//                function parseText()
//                {
//                    var html = document.documentElement.outerHTML
//                    var promisedText = (function() {
//"""
//        + mercuryPackage! + """
//            ; return Mercury.parse(document.location.toString(), {html: html, contentType: "text"})})()
//                    promisedText.then(result=>window.webkit.messageHandlers.htmlHandler.postMessage(result.content))
//                }
//                window.onload = parseText
//            """
//
//        webView = WKWebView(frame: UIScreen.main.bounds)
//        webView!.scrollView.contentInsetAdjustmentBehavior = .never
//
//        self.view = webView!
//
//        let script = WKUserScript(source: scriptToExtractRawText, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//        webView?.configuration.userContentController.addUserScript(script)
//        webView?.configuration.userContentController.add(self, name: "htmlHandler")
//
//        if let urlToLoad = urlString {
//            if let url = URL(string: urlToLoad) {
//                let request = URLRequest(url: url)
//                webView?.load(request)
//            }
//        }
//
//    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.delegate?.passRawtext(message.body as! String)
    }
    
}
