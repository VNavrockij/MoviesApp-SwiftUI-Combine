//
//  APIError.swift
//  MoviesApp
//
//  Created by Vitalii Navrotskyi on 16.11.2023.
//

import Foundation

enum APIError: Error {
    case decodingError
    case errorCode(Int)
    case unknown
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .decodingError:
                return "Failed to decode the object from the service"
            case .errorCode (let code):
                return "\(code) - Something went wrong"
            case .unknown:
                return "The error is unknown"
        }
    }
}
