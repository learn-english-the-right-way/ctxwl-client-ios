//
//  ParagraphGeneratorService.swift
//  up-english
//
//  Created by James Cai on 5/21/23.
//

import Foundation
import Combine

public struct ParagraphGeneratorResponse: Decodable {
    public var keyword: String
    public var content: String
}

public protocol ParagraphGeneratorService {
    var paragraph: AnyPublisher<ParagraphGeneratorResponse, Never> { get }
    func refresh() -> Void
}
