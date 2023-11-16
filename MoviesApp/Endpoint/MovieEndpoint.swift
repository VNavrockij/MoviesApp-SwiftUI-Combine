//
//  MovieEndpoint.swift
//  MoviesApp
//
//  Created by Vitalii Navrotskyi on 16.11.2023.
//

import Foundation

protocol APIBuilder {
    var urlRequest: URLRequest { get }
    var baseURL: URL { get }
    var path: String { get }
    var key: String { get }
}

enum MovieAPI {
    case getMovies
}

// https://api.themoviedb.org/3/movie/popular?api_key=34ed88cea1d738c801f4ab5b6e8058ca
extension MovieAPI: APIBuilder {
    var baseURL: URL {
        switch self {
            case .getMovies:
                return URL(string: "https://api.themoviedb.org/3/movie/")!
        }
    }
    
    var path: String {
        return "popular"
    }

    var key: String {
        return "?api_key=34ed88cea1d738c801f4ab5b6e8058ca"
    }

    var urlRequest: URLRequest {
        return URLRequest(url: self.baseURL.appendingPathComponent("\(self.path)\(self.key)"))
    }


}
