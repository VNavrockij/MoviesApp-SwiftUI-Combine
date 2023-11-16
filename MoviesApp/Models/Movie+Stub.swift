//
//  Movie+Stub.swift
//  MoviesApp
//
//  Created by Vitalii Navrotskyi on 16.11.2023.
//

import Foundation

extension Movie {
    static var stubbedMovies: [Movie] {
        let response: MoviesResponse? = try? Bundle.main.loadAndDecodeJSON(fileName: "movie_list")
        return response!.results
    }

    static var stubbedMovie: Movie {
        stubbedMovies[0]
    }
}

extension Bundle {
    func loadAndDecodeJSON<D: Decodable>(fileName: String) throws -> D? {
        guard let url = self.url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        let data = try Data(contentsOf: url)
        let jsonDecoder = Utils.jsonDecoder
        let decodeModel = try jsonDecoder.decode(D.self, from: data)
        return decodeModel
    }
}
