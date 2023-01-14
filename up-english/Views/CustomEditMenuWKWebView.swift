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
        case #selector(copy(_:)):
            return super.canPerformAction(action, withSender: sender)
        default:
            return false
        }
    }
    override func copy(_ sender: Any?) {
        super.copy(sender)
        print("on copy")
    }
}
