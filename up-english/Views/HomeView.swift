//
//  HomeView.swift
//  up-english
//
//  Created by James Tsai on 12/11/22.
//

import SwiftUI

@available(iOS 16.0, *)
struct HomeView: View {
    @State var presentAlert = true
    @ObservedObject var model: HomeModel
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
            .navigationTitle("Recommendations")
        }
        .onAppear {
            model.refresh()
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
