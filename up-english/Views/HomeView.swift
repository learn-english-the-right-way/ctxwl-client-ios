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
    
    var body: some View {
        VStack {
            TextField("URL", text: $model.url)
            Button("Launch") {
                model.openArticle()
            }
            .buttonStyle(.borderedProminent)
            .disabled(model.url == "")
        }
    }
}

@available(iOS 16.0, *)
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(model: HomeModel())
    }
}
