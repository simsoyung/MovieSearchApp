//
//  Movie.swift
//  MovieSearchApp
//
//  Created by 심소영 on 6/11/24.
//

import Foundation

struct Movie: Decodable {
    let page: Int
    let results: [Result]
    let total_pages, total_results: Int
}

struct Result: Decodable {
    let original_title: String
    let overview: String
    let title: String
    let poster_path: String
    let release_date: String
}

