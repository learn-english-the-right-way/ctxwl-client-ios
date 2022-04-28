//
//  ErrorMapper.swift
//  up-english
//
//  Created by James Tsai on 4/25/22.
//

import Foundation

protocol ErrorMapper {
    func mapToClientError(from error: Error) -> CTXWLClientError?
}
