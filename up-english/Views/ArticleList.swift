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
        // Using NavigationView to stack an article view on top of the article list view
        NavigationView {
            // need to use a ScrollView here on top instead of a List, as List does not support dynamic behavior of .onAppear
            ScrollView {
                // LazyVStack is required for dynamic item creation with onAppear()
                LazyVStack(alignment: .leading) {
                    // Loop through the array in the model
                    ForEach(model.content.indices, id: \.self) { index in
                        NavigationLink(destination: CustomWebView(urlString: model.content[index].url)) {
                            // A unit of article in the list
                                 VStack(alignment: .leading) {
                                     Text(model.content[index].title)
                                         .multilineTextAlignment(.leading)
                                     Text(model.content[index].brief)
                                         .multilineTextAlignment(.leading)
                                     Spacer()
                                 }
                                 .onAppear {
                                     // handler for more backend requests
                                     model.onItemAppear(index)
                                 }
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
