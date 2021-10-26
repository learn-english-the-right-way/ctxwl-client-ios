//
//  CustomWKWebView.swift
//  up-english
//
//  Created by James Tsai on 8/9/21.
//

import WebKit

class CustomContextMenuWKWebView: WKWebView {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch (action) {
        case #selector(copy(_:)), #selector(paste(_:)):
            return super.canPerformAction(action, withSender: sender)
        default:
            return false
        }
    }
    
    override func copy(_ sender: Any?) {
        super.copy(sender)
        print("on copy")
    }
    
    override func paste(_ sender: Any?) {
        super.paste(sender)
        print("on paste")
    }
}
