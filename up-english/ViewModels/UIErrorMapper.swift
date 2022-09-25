//
//  UIErrorMapper.swift
//  up-english
//
//  Created by James Tsai on 7/2/22.
//

import Foundation
import Combine

protocol UIErrorMapper {
    func mapError(_ serviceError: CLIENT_ERROR) -> UIEffect
}
