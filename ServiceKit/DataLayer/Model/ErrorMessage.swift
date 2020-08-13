//
//  ErrorMessage.swift
//

import Foundation

enum ErrorType: Error {
    case none
    case decoding
    case noResponse
    case connection
}

public struct ErrorMessage: Error {
    
    // MARK: - Properties
    public let id: UUID
    public let title: String
    public let message: String
    
    // MARK: Initializer
    public init(title: String, message: String) {
        self.id = UUID()
        self.title = title
        self.message = message
    }
}

extension ErrorMessage: Equatable {
    public static func ==(lhs: ErrorMessage, rhs: ErrorMessage) -> Bool {
        return lhs.id == rhs.id
    }
}
