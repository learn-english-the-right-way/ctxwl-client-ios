//
//  CustomWebView.swift
//  up-english
//
//  Created by James Tsai on 8/11/21.
//

import SwiftUI

protocol CustomWeb {
    var urlString: String { get set }
}

struct CustomWebView: CustomWeb, UIViewControllerRepresentable {
    
    var urlString: String
    
    @State var previousUrl: String?
    
    func makeUIViewController(context: Context) -> CustomWebUIViewController {
        let uiViewController = CustomWebUIViewController()
        uiViewController.urlString = urlString
        return uiViewController
    }
    
    func updateUIViewController(_ uiViewController: CustomWebUIViewController, context: Context) {
//        if (urlString != previousUrl) {
//            if let url = URL(string: urlString) {
//                let request = URLRequest(url: url)
//                uiViewController.webView?.load(request)
//            }
//            DispatchQueue.main.async {
//                previousUrl = urlString
//            }
//        }

    }
}

struct CustomWebView_Previews: PreviewProvider {
    static var previews: some View {
        CustomWebView(urlString: "https://apnews.com")
    }
}
