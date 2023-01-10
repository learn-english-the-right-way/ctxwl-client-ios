//
//  NoticeModifier.swift
//  up-english
//
//  Created by James Cai on 21/10/2022.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
struct NoticeModifier: ViewModifier {
    
    @EnvironmentObject var model: GeneralUIEffectManager
    @State var isPresented: Bool = false
    
    func body(content: Content) -> some View {
        content
            .alert("Error", isPresented: $isPresented) {
                Button("OK") {
                    model.removeEffect()
                }
            } message: {
                Text(model.alertContent)
            }
            .onReceive(model.showAlert) { toShow in
                if toShow != isPresented {
                    isPresented = toShow
                }
            }
    }
}

@available(iOS 15.0, *)
extension View {
    func noticeBanner() -> some View {
        self.modifier(NoticeModifier())
    }
}

@available(iOS 15.0, *)
struct NoticeBanner_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
