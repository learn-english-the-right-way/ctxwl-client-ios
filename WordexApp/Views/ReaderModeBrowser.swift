//
//  ReaderModeBrowser.swift
//  up-english
//
//  Created by James Cai on 2/16/23.
//

import SwiftUI
import WebKit

struct ReaderModeBrowser: UIViewControllerRepresentable {

    var readerModeHTMLString: Binding<String?>
    
    var url: Binding<String?>
    
    var selectionRange: Binding<NSRange?>
    
    func makeUIViewController(context: Context) -> ReaderModeBrowserViewController {
        let vc = ReaderModeBrowserViewController()
        vc.selectionRange = selectionRange
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ReaderModeBrowserViewController, context: Context) {
        guard let string = readerModeHTMLString.wrappedValue else {return}
        guard let urlString = url.wrappedValue else {return}
        let url = URL(string: urlString)
        uiViewController.webView.configuration.userContentController.removeAllUserScripts()
        uiViewController.webView.loadHTMLString(string, baseURL: url)
//        let cssFile = try! String(contentsOf: Bundle.main.url(forResource: "Reader", withExtension: "css")!)
//        let cssStyle = """
//            javascript:(function() {
//            var parent = document.getElementsByTagName('head').item(0);
//            var style = document.createElement('style');
//            style.type = 'text/css';
//            style.innerHTML = window.atob('\(encodeStringTo64(fromString: cssFile)!)');
//            parent.appendChild(style)})()
//        """
//        let cssScript = WKUserScript(source: cssStyle, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
//        uiViewController.webView.configuration.userContentController.addUserScript(cssScript)
    }
    
    private func encodeStringTo64(fromString: String) -> String? {
        let plainData = fromString.data(using: .utf8)
        return plainData?.base64EncodedString(options: [])
    }
}

struct ReaderModeBrowser_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
