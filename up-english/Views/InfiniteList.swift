//
//  InfiniteList.swift
//  up-english
//
//  Created by James Tsai on 11/9/21.
//

import SwiftUI
import Combine

struct InfiniteList<Data, Content>: View where Data: RandomAccessCollection, Data.Element: ArticleInfo, Content: View {
    @Binding var data: Data
    @Binding var isLoading: Bool
    let loadMore: () -> Void
    let content: (Data.Element) -> Content

    init(data: Binding<Data>, isLoading: Binding<Bool>, loadMore: @escaping () -> Void, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        _data = data
        _isLoading = isLoading
        self.loadMore = loadMore
        self.content = content
    }

    var body: some View {
        if #available(iOS 15.0, *) {
            NavigationView {
                List {
                    ForEach(data, id: \.self) { item in
                        content(item)
                            .onAppear {
                                if item == data.last {
                                    loadMore()
                                }
                            }
                    }
                    if isLoading {
                        ProgressView()
                            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
                    }
                }
                .onAppear(perform: loadMore)
                .refreshable {
                    
                }
            }
            
        } else {
            // Fallback on earlier versions
        }
    }
}

struct InfiniteList_Previews: PreviewProvider {
    struct ListItem: Hashable {
      let text: String
    }
    class ListViewModel: ObservableObject {
      @Published var items = [ListItem]()
      @Published var isLoading = false
      private var page = 1
      private var subscriptions = Set<AnyCancellable>()

      func loadMore() {
        guard !isLoading else { return }

          isLoading = true
                 (1...15).publisher
                   .map { index in ListItem(text: "Page: \(page) item: \(index)") }
                   .collect()
                   .delay(for: .seconds(2), scheduler: RunLoop.main)
                   .sink { [self] completion in
                     isLoading = false
                     page += 1
                   } receiveValue: { [self] value in
            items += value
          }
          .store(in: &subscriptions)
      }
    }
    @ObservedObject static var viewModel = ArticleListModelDefault(articleService: ArticleListServiceMockup())
    static var previews: some View {
        InfiniteList(data: $viewModel.items, isLoading: $viewModel.isLoading, loadMore: viewModel.loadMore) { item in
            ListItemView(title: item.title, brief: item.brief, url: item.url)
        }
    }
}

