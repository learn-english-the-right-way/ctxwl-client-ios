//
//  Home.swift
//  up-english
//
//  Created by James Tsai on 11/20/22.
//

import SwiftUI

@available(iOS 16.0, *)
struct ArticleOpener: View {
    
    @ObservedObject var model: ArticleOpenerModel
    
    var body: some View {
        ZStack {
            CustomWebView(url: $model.url, fullText: $model.fullText, readerModeHTMLString: $model.readerModeHTMLString, wordSelection: $model.selectedWord)
            ReaderModeBrowser(readerModeHTMLString: $model.readerModeHTMLString, url: $model.url, selectionRange: $model.lastSelectedRange)
                .ignoresSafeArea(.all, edges: .top)
                .opacity(model.showFullTextView ? 1 : 0)
            if model.fullText != nil {
                Button("Switch View") {
                    model.showFullTextView.toggle()
                }
                .buttonStyle(.borderedProminent)
                .offset(y: 280)
            }
        }
    }
}

@available(iOS 16.0, *)
struct ArticleOpener_Previews: PreviewProvider {
    static var previews: some View {
        ArticleOpener(model: ArticleOpenerModel(url: "https:// www.theverge.com"))
    }
}
