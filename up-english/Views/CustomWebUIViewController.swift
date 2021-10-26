//
//  WebViewController.swift
//  up-english
//
//  Created by James Tsai on 8/11/21.
//

import UIKit
import WebKit

class CustomWebUIViewController: UIViewController, WKScriptMessageHandler, UISearchBarDelegate, WKUIDelegate {
    
    var urlString: String?
    
    var webView: CustomContextMenuWKWebView?
    
    var searchBar: UISearchBar!
    
    var scriptToGetSelection = """
            function getSelectionAndSendMessage()
            {
                var text = document.getSelection().toString()
                window.webkit.messageHandlers.newSelectionDetected.postMessage(text)
            }
            document.ontouchend = getSelectionAndSendMessage
        """
    
    var term = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar = UISearchBar()
        webView = CustomContextMenuWKWebView()
        
        searchBar?.delegate = self
        searchBar?.sizeToFit()
        searchBar?.returnKeyType = .go
        searchBar?.keyboardType = .URL
        searchBar?.autocapitalizationType = .none
        
        let frame = CGRect(x: 0, y: searchBar.frame.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - searchBar.frame.height)
        webView?.frame = frame
        
        self.view.addSubview(searchBar!)
        self.view.addSubview(webView!)

        addCustomContextMenu()

        let script = WKUserScript(source: scriptToGetSelection, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        webView?.configuration.userContentController.addUserScript(script)
        webView?.configuration.userContentController.add(self, name: "newSelectionDetected")
        
        if let urlToLoad = urlString {
            if let url = URL(string: urlToLoad) {
                let request = URLRequest(url: url)
                webView?.load(request)
            }
        }

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar?.resignFirstResponder()
        if let searchText = self.searchBar?.text, let url = URL(string: searchText) {
            let request = URLRequest(url: url)
            self.webView?.load(request)
        }
    }

    func addCustomContextMenu() {
        let lookup = UIMenuItem(title: "王总天下第一", action: #selector(lookup))
        UIMenuController.shared.menuItems = [lookup]
    }
    
    @objc func lookup() {
        let lookupResult = UIReferenceLibraryViewController(term: term)
        present(lookupResult, animated: true)
        print(term)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.term = message.body as! String
    }
    
}
