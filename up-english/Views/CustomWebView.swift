//
//  CustomWebView.swift
//  up-english
//
//  Created by James Tsai on 8/11/21.
//

import SwiftUI

struct CustomWebView: UIViewControllerRepresentable {
    
    var url: Binding<String?>
    
    var fullText: Binding<String?>

    func makeUIViewController(context: Context) -> CustomWebViewController {
        let uiViewController = CustomWebViewController(url: url, fullText: fullText)        
        return uiViewController
    }
    
    func updateUIViewController(_ uiViewController: CustomWebViewController, context: Context) {
    }
}

struct CustomWebView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
