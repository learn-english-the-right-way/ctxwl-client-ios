//
//  ListItemView.swift
//  up-english
//
//  Created by Chen Zhao on 1/14/22.
//
//
//import SwiftUI
//
//struct ListItemView: View {
//    var title: String
//    var brief: String
//    var url: String
//
//    init(title: String, brief: String, url: String) {
//        self.title = title
//        self.brief = brief
//        self.url = url
//    }
//
//    var body: some View {
//        return NavigationLink {
//            CustomWebView(urlString: url)
//        } label: {
//            VStack(alignment: .center) {
//                Text(title).bold()
//                Text(brief)
//            }
//        }
//
//    }
//}
//
//struct ListItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListItemView(title: "1", brief: "wiki 1", url: "https://www.google.com")
//    }
//}
