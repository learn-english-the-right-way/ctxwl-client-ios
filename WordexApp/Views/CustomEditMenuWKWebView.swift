//
//  CustomEditMenuWKWebView.swift
//  up-english
//
//  Created by James Tsai on 1/14/23.
//

import Foundation
import WebKit

class CustomEditMenuWKWebView: WKWebView {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch (action) {
        case #selector(paste(_:)):
            return super.canPerformAction(action, withSender: sender)
        default:
            return false
        }
    }
    override func paste(_ sender: Any?) {
        super.paste(sender)
    }
    
    @objc func goHome() {
        load(URLRequest(url: URL(string: "https://google.com")!))
    }
}
