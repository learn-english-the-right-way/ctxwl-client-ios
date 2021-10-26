//
//  ArticleListItem.swift
//  up-english
//
//  Created by James Tsai on 9/12/21.
//

import SwiftUI

struct ArticleList<ModelType>: View where ModelType: ArticleListModel {
    
    @ObservedObject private var model: ModelType
    
    init(_ model: ModelType) {
        self.model = model
    }
    
    var body: some View {
        NavigationView {
            ScrollViewRepresentable {
                ForEach(model.content, id: \.self) { articleInfo in
                    NavigationLink(destination: CustomWebView(urlString: articleInfo.url)) {
                        VStack(alignment: .leading) {
                            Text(articleInfo.title)
                                .multilineTextAlignment(.leading)
                            Text(articleInfo.brief)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                }
            }

        }
    }
}

struct ArticleListItem_Previews: PreviewProvider {
    static var previews: some View {
        ArticleList(ArticleListModelMockup())
    }
}
