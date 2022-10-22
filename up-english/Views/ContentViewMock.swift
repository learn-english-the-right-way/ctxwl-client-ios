////
////  ContentViewMock.swift
////  up-english
////
////  Created by James Tsai on 10/24/21.
////
//
//import SwiftUI
//import Combine
//
//struct ContentViewMock: View {
//    
//    struct ListItem: Hashable {
//      let text: String
//    }
//    class ListViewModel: ObservableObject {
//      @Published var items = [ListItem]()
//      @Published var isLoading = false
//      private var page = 1
//      private var subscriptions = Set<AnyCancellable>()
//
//      func loadMore() {
//        guard !isLoading else { return }
//
//        isLoading = true
//        (1...15).publisher
//          .map { index in ListItem(text: "Page: \(page) item: \(index)") }
//          .collect()
//          .delay(for: .seconds(2), scheduler: RunLoop.main)
//          .sink { [self] completion in
//            isLoading = false
//            page += 1
//          } receiveValue: { [self] value in
//            items += value
//          }
//          .store(in: &subscriptions)
//      }
//    }
//    
//    @ObservedObject var viewModel = ArticleListModelDefault(articleService: ArticleListServiceMockup())
//    
//    var body: some View {
//        InfiniteList(data: $viewModel.items, isLoading: $viewModel.isLoading, refresh: viewModel.refresh ,loadMore: viewModel.loadMore) { item in
//            ListItemView(title: item.title, brief: item.brief, url: item.url)
//        }
//    }
//}
//
//struct ContentViewMock_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentViewMock()
//    }
//}
