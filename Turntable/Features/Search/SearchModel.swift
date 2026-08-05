//
//  SearchModel.swift
//  Turntable
//
//  Created by Aditya Rohman on 05/08/26.
//

import Foundation

enum SearchStatus {
    case idle
    case searching
    case found([Song])
    case failure(Error)
}

@MainActor
@Observable
class SearchModel {
    private let apiService: ApiService

    var term: String = ""
    var status: SearchStatus = .idle

    init(apiService: ApiService) {
        self.apiService = apiService
    }

    func search(for term: String) {
        Task {
            do {
                status = .searching
                let results = try await apiService.search(for: term)
                status = .found(results.songs)
            } catch {
                status = .failure(error)
            }
        }
    }
}
