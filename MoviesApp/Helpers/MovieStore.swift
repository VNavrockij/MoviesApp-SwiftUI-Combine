//
//  MovieStore.swift
//  MoviesApp
//
//  Created by Vitalii Navrotskyi on 15.11.2023.
//

import Foundation

class MovieStore: MovieService {
    static let shared = MovieStore()
    private init() {}

    ///movie/top_rated?api_key=
    private let apiKey = "34ed88cea1d738c801f4ab5b6e8058ca"
    private let baseURL = "https://api.themoviedb.org/3"
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utils.jsonDecoder

    func fetchMovies(from endpoint: MovieListEndpoint, completion: @escaping (Result<MoviesResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseURL)/movie/\(endpoint.rawValue)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecodable(url: url, completion: completion)
    }
    
    func fetchMovie(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseURL)/movie/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecodable(url: url, params: [
            "append_to_response": "videos,credits"
        ], completion: completion)
    }
    
    func searchMovie(query: String, completion: @escaping (Result<MoviesResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseURL)/search/movie") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecodable(url: url, params: [
            "language": "en-US",
            "include_adult": "false",
            "region": "US",
            "query": query
        ], completion: completion)
    }

    private func loadURLAndDecodable<D: Decodable>(url: URL, params: [String: String]? = nil, completion: @escaping (Result<D, MovieError>) -> ()) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }

        var queryItem = [URLQueryItem(name: "api_key", value: apiKey)]
        if let params = params {
            queryItem.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value)})
        }
        urlComponents.queryItems = queryItem

        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }

        urlSession.dataTask(with: finalURL) { [weak self] data, response, error in
            guard let self = self else { return }
            if error != nil {
                self.executeComplitionHandlerInMainTread(with: .failure(.apiError), completion: completion)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.executeComplitionHandlerInMainTread(with: .failure(.invalidResponse), completion: completion)
                return
            }

            guard let data = data else {
                self.executeComplitionHandlerInMainTread(with: .failure(.noData), completion: completion)
                return
            }

            do {
                let decoderResponse = try self.jsonDecoder.decode(D.self, from: data)
                self.executeComplitionHandlerInMainTread(with: .success(decoderResponse), completion: completion)
            } catch {
                self.executeComplitionHandlerInMainTread(with: .failure(.serializationError), completion: completion)
            }
        }.resume()
    }

    private func executeComplitionHandlerInMainTread<D: Decodable>(with result: Result<D, MovieError>, completion: @escaping (Result<D, MovieError>) -> ()) {
        DispatchQueue.main.async {
            completion(result)
        }
    }



}
