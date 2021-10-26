//
//  ContentViewMock.swift
//  up-english
//
//  Created by James Tsai on 10/24/21.
//

import SwiftUI

struct ContentViewMock: View {
    var body: some View {
        ArticleList(ArticleListModelMockup())
    }
}

struct ContentViewMock_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewMock()
    }
}
