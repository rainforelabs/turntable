//
//  PlayerModel.swift
//  Turntable
//
//  Created by Aditya Rohman on 05/08/26.
//

import AVFoundation
import Foundation

@MainActor
@Observable
class PlayerModel {
    private let playerService: AudioPlayerService

    var queue: [Song] = []
    private(set) var currentIndex: Int?

    var currentSong: Song? {
        guard let currentIndex else { return nil }
        return queue[currentIndex]
    }

    var currentTime: TimeInterval = 0
    var duration: TimeInterval = 0
    var isPlaying = false

    init(player: AudioPlayerService) {
        self.playerService = player

        Task {
            for await state in player.playbackState {
                currentTime = state.currentTime
                duration = state.duration
                isPlaying = state.isPlaying
            }
        }
    }

    func play(song: Song, in queue: [Song]) {
        self.queue = queue

        guard let index = queue.firstIndex(where: { $0.id == song.id }) else { return }
        currentIndex = index

        playCurrentSong()
    }

    func pause() {
        playerService.pause()
    }

    func resume() {
        playerService.resume()
    }

    func togglePlayback() {
        isPlaying ? pause() : resume()
    }

    func seek(to seconds: TimeInterval) {
        playerService.seek(to: seconds)
    }

    func next() {
        guard let currentIndex else { return }
        let nextIndex = currentIndex + 1

        guard queue.indices.contains(nextIndex) else { return }

        self.currentIndex = nextIndex
        playCurrentSong()
    }

    func previous() {
        if currentTime > 3 {
            seek(to: 0)
            return
        }

        guard let currentIndex else { return }
        let previousIndex = currentIndex - 1

        guard queue.indices.contains(previousIndex) else {
            seek(to: 0)
            return
        }

        self.currentIndex = previousIndex
        playCurrentSong()
    }

    // MARK: - Private helpers

    private func playCurrentSong() {
        guard let song = currentSong else { return }
        playerService.play(song: song)
    }
}
