//
//  ErrorMapper.swift
//  up-english
//
//  Created by James Tsai on 4/25/22.
//

import Foundation

public protocol ErrorMapper {
    func mapToClientError(from error: Error) -> CLIENT_ERROR?
}
