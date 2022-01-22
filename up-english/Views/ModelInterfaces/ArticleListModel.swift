//
//  ArticleListModel.swift
//  up-english
//
//  Created by James Tsai on 9/12/21.
//

import Foundation

protocol ArticleInfo: Hashable {
    var title: String {get}
    var brief: String {get}
    var url: String {get}
}

protocol ArticleListModel: ObservableObject {
    associatedtype itemType
    var items: [itemType] { get set }
    var isLoading: Bool { get set }
    func loadMore() -> Void
}


