//
//  ArticleReaderView.swift
//  up-english
//
//  Created by James Tsai on 8/15/21.ni
//

import SwiftUI

struct ArticleReaderViewRepresentable: UIViewControllerRepresentable {
    
    class ViewControllerDelegate: ArticleReaderViewControllerDelegate {
        
        private var rangeBinding: Binding<UITextRange?>
        
        init(_ rangeBinding: Binding<UITextRange?>) {
            self.rangeBinding = rangeBinding
        }
        
        func updateRange(_ range: UITextRange?) {
            self.rangeBinding.wrappedValue = range
        }
    }
    
    typealias Coordinator = ViewControllerDelegate
    
    var text: String

    @Binding var range: UITextRange?
    
    func makeUIViewController(context: Context) -> ArticleReaderViewController {
        let viewController = ArticleReaderViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ArticleReaderViewController, context: Context) {
        uiViewController.updateText(newText: text)
        if (Optional.some($range.wrappedValue) != uiViewController.intendedRange) {
            uiViewController.intendedRange = $range.wrappedValue
            uiViewController.acceptedActualRange = nil
            uiViewController.textView?.selectedTextRange = $range.wrappedValue
            uiViewController.acceptedActualRange = uiViewController.actualRange
        }

    }
    
    func makeCoordinator() -> Self.Coordinator {
        return Coordinator($range)
    }
}

struct ArticleReaderView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleReaderViewRepresentable(text: "not suitable for children under 15 years of age or pregnant soeijfosiejf soiejfosiejfosijef soiejfosiejfosijefosijef oisjefoisjefoisjeofij osiejfosiejfosijefosejfosiejfosiejfosiejfosijefosiejfosiejfosifj.", range: State(wrappedValue: UITextRange()).projectedValue)
    }
}

