//
//  Movie.swift
//  Netflix Clone
//
//  Created by Всеволод Буртик on 19.12.2024.
//

import Foundation

struct TrendingMoviesResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let media_type: String?
    let title: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
//    let vote_average: Int
    let adult: Bool
}

//"backdrop_path": "/4cp40IyTpFfsT2IKpl0YlUkMBIR.jpg",
//      "id": 1064213,
//      "title": "Anora",
//      "original_title": "Anora",
//      "overview": "A young sex worker from Brooklyn gets her chance at a Cinderella story when she meets and impulsively marries the son of an oligarch. Once the news reaches Russia, her fairytale is threatened as his parents set out to get the marriage annulled.",
//      "poster_path": "/7MrgIUeq0DD2iF7GR6wqJfYZNeC.jpg",
//      "media_type": "movie",
//      "adult": false,
//      "original_language": "en",
//      "genre_ids": [
//        10749,
//        35,
//        18
//      ],
//      "popularity": 223.013,
//      "release_date": "2024-10-14",
//      "video": false,
//      "vote_average": 7.3,
//      "vote_count": 378


