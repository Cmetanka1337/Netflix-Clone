//
//  YouTubeVideoResponse.swift
//  Netflix Clone
//
//  Created by Всеволод Буртик on 25.12.2024.
//

import Foundation

struct YouTubeVideoResponse: Codable {
    let items: [YouTubeElement]
}

struct YouTubeElement: Codable {
    let id: IdYouTubeElements
}

struct IdYouTubeElements: Codable {
    let kind: String
    let videoId: String
}
