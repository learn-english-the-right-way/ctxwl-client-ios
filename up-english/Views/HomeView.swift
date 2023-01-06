//
//  HomeView.swift
//  up-english
//
//  Created by James Tsai on 12/11/22.
//

import SwiftUI

@available(iOS 16.0, *)
struct HomeView: View {
    
    @ObservedObject var model: HomeModel
    @EnvironmentObject var viewModelFactory: ViewModelFactory
    
    var body: some View {
        NavigationStack {
            List(model.articleItems) { item in
                NavigationLink(item.title, value: item)
            }
            .navigationDestination(for: ArticleListItem.self) { item in
                ArticleOpener(model: viewModelFactory.createArticleOpenerModel(url: item.url))
            }
        }
//        VStack {
//            Text("home view")
//            TextField("URL", text: $model.url)
//            Button("Launch") {
//                model.openArticle()
//            }
//            .buttonStyle(.borderedProminent)
//            .disabled(model.url == "")
//        }
    }
}

@available(iOS 16.0, *)
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
//        HomeView(model: HomeModel())
    }
}
