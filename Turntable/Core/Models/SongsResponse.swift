//
//  SongsResponse.swift
//  Turntable
//
//  Created by Aditya Rohman on 05/08/26.
//

import Foundation

struct SongsResponse: Decodable {
    let count: Int
    let songs: [Song]

    enum CodingKeys: String, CodingKey {
        case count = "resultCount"
        case songs = "results"
    }
}

extension SongsResponse {
    static let empty: Self = .init(count: 0, songs: [])
}
