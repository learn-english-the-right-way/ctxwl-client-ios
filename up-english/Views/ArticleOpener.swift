//
//  Home.swift
//  up-english
//
//  Created by James Tsai on 11/20/22.
//

import SwiftUI

struct ArticleOpener: View {
    
    @ObservedObject var model: ArticleOpenerModel
    
    var body: some View {
        CustomWebView(urlString: model.url, fullTextBinding: $model.fullText)
            .popover(isPresented: $model.showFullText) {
                SelectionRangeEnabledTextViewRepresentable(text: model.fullText!, range: $model.lastSelectedRange)
            }
            .onDisappear {
                model.finishReading()
            }
    }
}

struct ArticleOpener_Previews: PreviewProvider {
    static var previews: some View {
        ArticleOpener(model: ArticleOpenerModel(url: "https:// www.theverge.com/2022/11/24/23445995/dish-5g-network-genesis-las-vegas-trial"))
    }
}
