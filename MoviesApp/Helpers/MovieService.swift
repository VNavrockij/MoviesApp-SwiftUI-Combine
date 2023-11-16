//
//  MovieService.swift
//  MoviesApp
//
//  Created by Vitalii Navrotskyi on 15.11.2023.
//

import Foundation

protocol MovieService {
    func fetchMovies(from endpoint: MovieListEndpoint, completion: @escaping (Result<MoviesResponse, MovieError>) -> ())
    func fetchMovie(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ())
    func searchMovie(query: String, completion: @escaping (Result<MoviesResponse, MovieError>) -> ())

}

enum MovieListEndpoint: String, CaseIterable {
    case yourRecomendation = "your_recommendations"
    case popular

    var descripton: String {
        switch self {
            case .yourRecomendation: return "Your recommendations"
            case .popular: return "Popular"
        }
    }
}

enum MovieError: Error, CustomNSError {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError

    var localDescription: String {
        switch self {
            case .apiError: return "Failed to fetch data"
            case .invalidEndpoint: return "Invalid endpoint"
            case .invalidResponse: return "Invalid response"
            case .noData: return "No data"
            case .serializationError: return "Failed to decode data"
        }
    }

    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localDescription]
    }
}
