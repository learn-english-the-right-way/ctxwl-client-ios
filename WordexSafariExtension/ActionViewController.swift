//
//  ActionViewController.swift
//  wordex-action-extension
//
//  Created by James Cai on 3/11/23.
//

import UIKit
import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers
import WebKit

class ActionViewController: UIViewController {
    
    var services = ExtensionServiceInitializer()
        
    var htmlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func encodeStringTo64(fromString: String) -> String? {
            let plainData = fromString.data(using: .utf8)
            return plainData?.base64EncodedString(options: [])
        }
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    print(javaScriptValues)
                    
                    let html = javaScriptValues["newHTMLString"] as? String ?? ""
                    let fullText = javaScriptValues["fullText"] as? String ?? ""

                    if let childVC = self?.children.first(where: { $0 is ActionExtensionReaderModeBrowserViewController }) as? ActionExtensionReaderModeBrowserViewController {
                        // Do something with the child view controller
                        childVC.service = self?.services.articleReadingService
                        childVC.fullText = fullText
                        childVC.webView.loadHTMLString(html, baseURL: nil)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToReader" {
            let readerVC = segue.destination as! ActionExtensionReaderModeBrowserViewController
            if let html = self.htmlString {
                readerVC.webView.loadHTMLString(html, baseURL: nil)
            }
        }
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
