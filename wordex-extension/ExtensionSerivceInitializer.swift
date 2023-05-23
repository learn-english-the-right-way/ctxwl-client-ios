//
//  ExtensionSerivceInitializer.swift
//  wordex-extension
//
//  Created by James Cai on 5/23/23.
//

import Foundation
import WordexServices

class ExtensionServiceInitializer {
    var ctxwlUserSession: CTXWLURLSession
    var userService: UserService
    var articleReadingService: ArticleReadingService
    
    init() {
        self.ctxwlUserSession = CTXWLURLSessionDefault()
        self.userService = UserServiceDefault(ctxwlUrlSession: self.ctxwlUserSession)
        self.articleReadingService = ArticleReadingServiceDefault(sessionConnectionService: self.userService)
    }
}
