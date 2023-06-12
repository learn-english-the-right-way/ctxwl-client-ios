//
//  CustomWebView.swift
//  up-english
//
//  Created by James Tsai on 8/11/21.
//

import SwiftUI

struct CustomWebView: UIViewControllerRepresentable {
    
    var url: Binding<String?>
    
    var fullText: Binding<String?>
    
    var readerModeHTMLString: Binding<String?>
    
    var wordSelection: Binding<String?>

    func makeUIViewController(context: Context) -> CustomWebViewController {
        let uiViewController = CustomWebViewController(url: url, fullText: fullText, readerModeHTMLString: readerModeHTMLString, wordSelection: wordSelection)
        return uiViewController
    }
    
    func updateUIViewController(_ uiViewController: CustomWebViewController, context: Context) {
    }
}

struct CustomWebView_Previews: PreviewProvider {
    @State static var url: String? = "https://google.com"
    @State static var fullText: String? = nil
    @State static var readerModeHTMLString: String? = nil
    @State static var wordSelection: String? = nil
    static var previews: some View {
        CustomWebView(url: $url, fullText: $fullText, readerModeHTMLString: $readerModeHTMLString, wordSelection: $wordSelection)
    }
}
