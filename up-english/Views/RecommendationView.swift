//
//  HomeView.swift
//  up-english
//
//  Created by James Tsai on 12/11/22.
//

import SwiftUI

@available(iOS 16.0, *)
struct RecommendationView: View {
    @State var presentAlert = true
    @ObservedObject var model: RecommendationViewModel
    @EnvironmentObject var viewModelFactory: ViewModelFactory
    
    var body: some View {
        NavigationStack {
            List() {
                ForEach(model.articleItems) { item in
                    NavigationLink(value: item) {
                        ArticleRow(article: item)
     
                    }
                }
                Text("loading...")
                    .foregroundColor(.secondary)
                    .onAppear {
                        model.loadMore()
                    }
            }
            .navigationDestination(for: ArticleListItem.self) { item in
                ArticleOpener(model: viewModelFactory.createArticleOpenerModel(url: item.url))
            }
            .navigationTitle("For You")
            .refreshable {
                model.refresh()
            }
            .onAppear {
                model.refresh()
            }
        }
    }
}

@available(iOS 16.0, *)
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
//        HomeView(model: HomeModel())
    }
}
