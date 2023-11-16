//
//  ResultState.swift
//  MoviesApp
//
//  Created by Vitalii Navrotskyi on 16.11.2023.
//

import Foundation

enum ResultState {
    case loading
    case success(content: [Movie])
    case failed(error: Error)
}
