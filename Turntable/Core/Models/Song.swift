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
    let album: String?
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

extension Song {
    static var sample: [Self] {
        [
            .init(
                id: 1_848_275_657,
                title: "LUCKY",
                artist: "TOMOO",
                album: "DEAR MYSTERIES",
                artworkUrl: URL(
                    string:
                        "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/00/1b/58/001b58d1-7ca1-c16c-0e0f-723194ba6a88/PCSP_06898_A.jpg/100x100bb.jpg"
                )!,
                previewUrl: URL(
                    string:
                        "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview221/v4/87/23/01/872301a1-2e5b-662e-4f55-7f1ca1ac0546/mzaf_6935446120243342013.plus.aac.p.m4a"
                )!,
                duration: 212988
            ),
            .init(
                id: 1_601_369_901,
                title: "Superstar",
                artist: "TOMOO",
                album: "Superstar - Single",
                artworkUrl: URL(
                    string:
                        "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/98/9a/4a/989a4a66-315e-e175-ed30-31c0e4cba558/859757721498_cover.jpg/100x100bb.jpg"
                )!,
                previewUrl: URL(
                    string:
                        "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview116/v4/5c/c0/00/5cc0007e-4e49-3003-6c50-aba7d23d7fa1/mzaf_6330858776236192.plus.aac.p.m4a"
                )!,
                duration: 231405
            ),
        ]
    }
}
