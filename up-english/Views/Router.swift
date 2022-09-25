//
//  Router.swift
//  up-english
//
//  Created by James Tsai on 8/13/22.
//

import Foundation
import SwiftUI

@available(iOS 16.0, *)
class Router: ObservableObject {
    
    @Published var path = NavigationPath()
    
    func clearStackAndGoTo(page: PageInfo) {
        path.removeLast(path.count)
        path.append(page)
    }
    func append(page: PageInfo) {
        path.append(page)
    }
    
    func back() {
        path.removeLast(1)
    }
}

