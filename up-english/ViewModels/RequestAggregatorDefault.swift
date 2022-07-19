//
//  RequestAggregatorDefault.swift
//  up-english
//
//  Created by James Tsai on 7/2/22.
//

import Foundation
import Combine

class RequestAggregatorDefault<UserServiceType>: RequestAggregator where UserServiceType: UserService {
    
    private var userService: UserServiceType
    
    private var uiErrorMapper: UIErrorMapper
    
    init(userService: UserServiceType, uiErrorMapper: UIErrorMapper) {
        self.userService = userService
        self.uiErrorMapper = uiErrorMapper
    }
    
    func login() -> AnyPublisher<UIException, Never> {
        return self.userService.login()
            .flatMap{ value -> Empty<UIException, Never> in
                Empty<UIException, Never>()
            }
            .catch { error -> Just<UIException> in
                self.uiErrorMapper.mapError(error)
            }
            .eraseToAnyPublisher()
    }
    
}
