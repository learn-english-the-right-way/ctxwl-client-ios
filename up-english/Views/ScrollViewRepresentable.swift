//
//  ScrollViewRepresentable.swift
//  up-english
//
//  Created by James Tsai on 9/22/21.
//

import SwiftUI

struct ScrollViewRepresentable<Content: View>: UIViewControllerRepresentable {
    
    class UIScrollViewController: UIViewController {
        
        var scrollView: UIScrollView!
        
        var hostingController: UIHostingController<Content>!
        
        override func loadView() {
            scrollView = UIScrollView()
            scrollView.isDirectionalLockEnabled = true
            self.view = scrollView
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.hostingController.willMove(toParent: self)
            addChild(hostingController)
            view.addSubview(hostingController.view)
            self.pinEdges(of: self.hostingController.view, to: self.view)
            hostingController.didMove(toParent: self)

        }
        
        func pinEdges(of viewA: UIView, to viewB: UIView) {
            viewA.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                viewA.leadingAnchor.constraint(equalTo: viewB.leadingAnchor),
                viewA.trailingAnchor.constraint(equalTo: viewB.trailingAnchor),
                viewA.topAnchor.constraint(equalTo: viewB.topAnchor),
                viewA.bottomAnchor.constraint(equalTo: viewB.bottomAnchor),
//                viewA.widthAnchor.constraint(equalTo: viewB.widthAnchor)
            ])
            
        }
    }
    
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    func makeUIViewController(context: Context) -> UIScrollViewController {
        let svc = UIScrollViewController()
        svc.hostingController = UIHostingController(rootView: content())
        return svc
    }
    
    func updateUIViewController(_ vc: UIScrollViewController, context: Context) {
        
    }
    
}

