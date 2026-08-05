//
//  SongListView.swift
//  Turntable
//
//  Created by Aditya Rohman on 05/08/26.
//

import SwiftUI

struct SongListView: View {
    let songs: [Song]

    @Environment(PlayerModel.self) private var playerModel

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(songs) { song in
                    SongCardView(
                        song: song,
                        isPlaying: playerModel.currentSong?.id == song.id
                            && playerModel.isPlaying
                    ) { playerModel.play(song: song, in: songs) }
                }
            }
            .padding(20)
        }
        .scrollIndicators(.hidden)
    }
}

private struct SongCardView: View {
    let song: Song
    var isPlaying: Bool = false
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top) {
                AsyncImage(url: song.artworkUrl)
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .clipShape(.rect(cornerRadius: 8))

                VStack(alignment: .leading) {
                    Text(song.title)
                        .fontWeight(.semibold)
                    Text(song.artist)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    if let album = song.album, !album.lowercased().contains("single") {
                        Text(album)
                            .font(.subheadline)
                            .foregroundStyle(.tertiary)
                    } else {
                        Text("Single")
                            .font(.subheadline)
                            .foregroundStyle(.tertiary)
                    }
                }
                .lineLimit(1)

                if isPlaying {
                    Spacer(minLength: 16)
                    Image(systemName: "waveform.mid")
                        .font(.title3)
                        .symbolEffect(.pulse)
                        .padding(.vertical, 4)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SongListView(songs: Song.sample)
        .appBackground()
}
