//
//  Song.swift
//  Turntable
//
//  Created by Aditya Rohman on 05/08/26.
//

import Foundation

struct Song: Decodable, Identifiable {
    let id: Int
    let title: String
    let artist: String
    let album: String
    let artworkUrl: URL
    let previewUrl: URL
    let duration: TimeInterval

    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case title = "trackName"
        case artist = "artistName"
        case album = "collectionName"
        case artworkUrl = "artworkUrl100"
        case previewUrl = "previewUrl"
        case duration = "trackTimeMillis"
    }
}

extension Song {
    var durationSeconds: TimeInterval {
        duration / 1_000
    }
}
