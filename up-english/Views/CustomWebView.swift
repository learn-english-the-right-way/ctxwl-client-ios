//
//  CustomWebView.swift
//  up-english
//
//  Created by James Tsai on 8/11/21.
//

import SwiftUI

struct CustomWebView: UIViewControllerRepresentable {
    
    class Coordinator: CustomWebViewControllerDelegate {
        var fullTextBinding: Binding<String?>
        
        init(fullTextBinding: Binding<String?>) {
            self.fullTextBinding = fullTextBinding
        }
        
        func passRawtext(_ text: String) {
            self.fullTextBinding.wrappedValue = text
        }
    }
    
    var urlString: String
    
    var fullTextBinding: Binding<String?>
    
    func makeCoordinator() -> Coordinator {
        Coordinator(fullTextBinding: self.fullTextBinding)
    }
        
    func makeUIViewController(context: Context) -> CustomWebViewController {
        let uiViewController = CustomWebViewController()
        uiViewController.delegate = context.coordinator
        uiViewController.urlString = urlString
        
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
