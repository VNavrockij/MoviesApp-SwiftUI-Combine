//
//  MovieService.swift
//  MoviesApp
//
//  Created by Vitalii Navrotskyi on 16.11.2023.
//

import Foundation
import Combine

protocol MovieService {
    func request(from endpoint: MovieAPI) -> AnyPublisher<MoviesResponse, APIError>
}

struct MovieServiceImpl: MovieService {
    func request(from endpoint: MovieAPI) -> AnyPublisher<MoviesResponse, APIError> {
        return URLSession
            .shared
            .dataTaskPublisher(for: endpoint.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { _ in APIError.unknown }
            .flatMap { data, response -> AnyPublisher<MoviesResponse, APIError> in
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: APIError.unknown).eraseToAnyPublisher()
                }

                if (200...299).contains(response.statusCode) {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .iso8601
                    return Just(data).decode(type: MoviesResponse.self, decoder: jsonDecoder)
                        .mapError { _ in APIError.decodingError }
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: APIError.errorCode(response.statusCode)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    

}
