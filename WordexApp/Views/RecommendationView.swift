//
//  HomeView.swift
//  up-english
//
//  Created by James Tsai on 12/11/22.
//

import SwiftUI

@available(iOS 16.0, *)
struct RecommendationView: View {
    @State var loading = false
    @State var showWord = false
    @State var word = ""
    @State var paragraph = ""
    @EnvironmentObject var services: ServiceInitializer
    var body: some View {
        VStack {
            if showWord {
                Text(word)
            }
            Spacer()
            Text(paragraph)
            Spacer()
            HStack {
                Button("Load") {
                    self.showWord = false
                    self.loading = true
                    services.paragraphGeneratorService.refresh()
                }
                .buttonStyle(.borderedProminent)
                .disabled(self.loading)
                Button("Show Word") {
                    self.showWord = true
                }
                .buttonStyle(.bordered)
                .disabled(self.word == "")
            }

        }
        .padding()
        .onReceive(services.paragraphGeneratorService.paragraph.receive(on: DispatchQueue.main)) { response in
            self.word = response.keyword
            self.paragraph = response.content
            self.loading = false
        }
    }
}

@available(iOS 16.0, *)
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
