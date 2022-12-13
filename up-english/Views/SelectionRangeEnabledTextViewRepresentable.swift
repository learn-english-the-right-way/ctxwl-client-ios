//
//  SelectionRangeEnabledTextViewRepresentable.swift
//  up-english
//
//  Created by James Tsai on 12/3/22.
//

import SwiftUI

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
    }
    
    var text: String

    @Binding var range: NSRange?
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.delegate = context.coordinator
        return view
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

