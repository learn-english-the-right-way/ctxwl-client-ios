//
//  ArticleReaderViewController.swift
//  up-english
//
//  Created by James Tsai on 8/16/21.
//

import Foundation
import UIKit
import SwiftUI

protocol ArticleReaderViewControllerDelegate {
    func updateRange(_ range: UITextRange?) -> Void
}

class ArticleReaderViewController: UIViewController, UITextViewDelegate {
    
    var delegate: ArticleReaderViewControllerDelegate?
    
    var previousText: String?
        
    var textView: UITextView?
    
    var intendedRange: UITextRange??
    
    var actualRange: UITextRange?
    
    var acceptedActualRange: UITextRange??
    
    override func loadView() {
        textView = UITextView()
        textView?.delegate = self
        textView?.isEditable = false
        view = textView
    }
    
    func updateText(newText: String) {
        if (previousText != newText) {
            textView?.text = newText
            previousText = newText
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        actualRange = textView.selectedTextRange
        if (acceptedActualRange != nil) {
            if (acceptedActualRange != actualRange) {
                intendedRange = actualRange
                delegate?.updateRange(actualRange)
                acceptedActualRange = actualRange
            }
        }
    }
}
