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
            CustomWebView(url: $model.url, fullText: $model.fullText)
            if model.showFullTextView == true {
                SelectionRangeEnabledTextViewRepresentable(text: model.fullText!, range: $model.lastSelectedRange)
            }
            if model.fullText != nil {
                Button("Switch View") {
                    model.showFullTextView.toggle()
                }
                .buttonStyle(.borderedProminent)
                .offset(y: 350)
            }
        }
        .ignoresSafeArea()
    }
}

@available(iOS 16.0, *)
struct ArticleOpener_Previews: PreviewProvider {
    static var previews: some View {
        ArticleOpener(model: ArticleOpenerModel(url: "https:// www.theverge.com"))
    }
}
