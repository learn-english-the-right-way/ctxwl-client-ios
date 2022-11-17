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
    
    @ObservedObject var model: GeneralUIEffectManager
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if model.showNotice {
                VStack {
                    HStack {
                        Spacer()
                        Text(model.noticeContent)
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .background(.gray)
                    .padding(12)
                    .cornerRadius(8)
                    Spacer()
                }
                .onTapGesture {
                    model.showNotice = false
                }
            }
        }
    }
}

@available(iOS 15.0, *)
extension View {
    func noticeBanner(_ model: GeneralUIEffectManager) -> some View {
        self.modifier(NoticeModifier(model: model))
    }
}

@available(iOS 15.0, *)
struct NoticeBanner_Previews: PreviewProvider {
    struct Model {
        var realModel: GeneralUIEffectManager
        init() {
            self.realModel = GeneralUIEffectManager()
            self.realModel.noticeContent = "test notice content"
            self.realModel.showNotice = true
        }
    }
    static var previews: some View {
        VStack {
            Text("test")
        }
        .noticeBanner(Model().realModel)
    }
}
