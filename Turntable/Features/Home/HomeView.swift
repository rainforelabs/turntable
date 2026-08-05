//
//  HomeView.swift
//  Turntable
//
//  Created by Aditya Rohman on 05/08/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(SearchModel.self) private var searchModel
    @Environment(PlayerModel.self) private var playerModel

    @State private var searchTerm: String = ""

    var body: some View {
        NavigationStack {
            Group {
                switch searchModel.status {
                case .idle:
                    VStack(spacing: 16) {
                        Image(systemName: "waveform.badge.magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 32)
                            .foregroundStyle(.cyan)
                        Text("Search for songs, artists or albums")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                case .searching:
                    ProgressView("Searching")
                        .progressViewStyle(CircularProgressViewStyle(tint: .cyan))
                        .scaleEffect(1.2)
                case .found(let songs):
                    if songs.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 32)
                            Text("No results found for \(searchTerm)")
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    } else {
                        SongListView(songs: songs)
                    }
                case .failure(let error):
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 32)
                            .foregroundStyle(.orange)
                        Text(error.localizedDescription)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .appBackground()
            .toolbar(.hidden, for: .navigationBar)
            .safeAreaBar(edge: .top) {
                HStack {
                    Image(.brand)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                    Text("Turntable.")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
            }
            .safeAreaBar(edge: .bottom) {
                if playerModel.currentSong != nil {
                    PlayerView()
                }
            }
        }
        .onAppear { searchModel.search(for: "hindia") }
        .searchable(text: $searchTerm)
        .task(id: searchTerm) {
            guard !searchTerm.isEmpty else { return }
            try? await Task.sleep(nanoseconds: 300_000_000)
            searchModel.search(for: searchTerm)
        }
    }
}

#Preview {
    HomeView()
        .inject(AppModel())
}
