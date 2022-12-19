//
//  SelectionRangeEnabledTextViewRepresentable.swift
//  up-english
//
//  Created by James Tsai on 12/3/22.
//

import SwiftUI

@available(iOS 16.0, *)
struct SelectionRangeEnabledTextViewRepresentable: UIViewRepresentable {
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        private var rangeBinding: Binding<NSRange?>
        
        init(_ rangeBinding: Binding<NSRange?>) {
            self.rangeBinding = rangeBinding
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            if textView.selectedRange.length > 0 {
                self.rangeBinding.wrappedValue = textView.selectedRange
            }
        }
        
        func textView(_ textView: UITextView, editMenuForTextIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
            let lookupOption = UIAction(title: "Look up") { action in
                if textView.selectedRange.length > 0 {
                    self.rangeBinding.wrappedValue = range
                }
                
                let textViewController = textView.findViewController()!
                let dictionaryViewController = UIReferenceLibraryViewController(term: String(textView.text[Range(range, in: textView.text)!]))
                textViewController.present(dictionaryViewController, animated: true)
            }
            
            return UIMenu(children: [lookupOption])
        }
    }
    
    var text: String

    @Binding var range: NSRange?
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView(frame: UIScreen.main.bounds)
        let textViewController = UIViewController()
        textViewController.view = textView
        textView.delegate = context.coordinator
        return textView
        
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Self.Coordinator {
        return Coordinator($range)
    }
}

struct ArticleReaderView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
