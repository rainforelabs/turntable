//
//  ApiService.swift
//  Turntable
//
//  Created by Aditya Rohman on 05/08/26.
//

import Foundation

enum ApiServiceError: LocalizedError {
    case networkError(Int)

    var errorDescription: String? {
        switch self {
        case .networkError(let code): "Network error \(code)"
        }
    }
}

struct ApiService {
    private let baseUrl = "https://itunes.apple.com"

    func search(for term: String) async throws -> SongsResponse {
        guard !term.isEmpty else { return SongsResponse.empty }

        var urlComponents = URLComponents(string: "\(baseUrl)/search")!
        urlComponents.queryItems = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "media", value: "music"),
            URLQueryItem(name: "entity", value: "song"),
        ]

        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        try handleStatus(response, data)
        return try JSONDecoder().decode(SongsResponse.self, from: data)
    }

    // MARK: - Private helpers

    private func handleStatus(_ response: URLResponse, _ data: Data) throws {
        guard let http = response as? HTTPURLResponse else { return }
        switch http.statusCode {
        case 200...299: return
        default: throw ApiServiceError.networkError(http.statusCode)
        }
    }
}
