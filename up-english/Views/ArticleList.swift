//
//  ArticleList.swift
//  up-english
//
//  Created by James Tsai on 22/1/2022.
//

import SwiftUI

struct ArticleList<ListModelType>: View where ListModelType: ArticleListModel {
    
    @ObservedObject var articleListModel: ListModelType
    
    var body: some View {
        InfiniteList(
            data: $articleListModel.items,
            isLoading: $articleListModel.isLoading,
            refresh: articleListModel.refresh,
            loadMore: articleListModel.loadMore
        ) { item in
            ListItemView(title: item.title, brief: item.brief, url: item.url)
        }
    }
}

struct ArticleList_Previews: PreviewProvider {
    @ObservedObject static var viewModel = ArticleListModelDefault(articleService: ArticleListServiceMockup())
    static var previews: some View {
        ArticleList(articleListModel: viewModel)
    }
}
