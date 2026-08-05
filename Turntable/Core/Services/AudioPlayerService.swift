//
//  AudioPlayerService.swift
//  Turntable
//
//  Created by Aditya Rohman on 05/08/26.
//

import AVFoundation
import Foundation

struct PlaybackState {
    let currentTime: TimeInterval
    let duration: TimeInterval
    let isPlaying: Bool
}

protocol AudioPlayer {
    var playbackState: AsyncStream<PlaybackState> { get }

    func play(song: Song)
    func pause()
    func resume()
    func seek(to seconds: Double)
}

final class AudioPlayerService: AudioPlayer {
    private let player = AVPlayer()

    private let continuation: AsyncStream<PlaybackState>.Continuation
    let playbackState: AsyncStream<PlaybackState>

    private var timeObserver: Any?
    private var playbackEndObserver: NSObjectProtocol?

    init() {
        var continuation: AsyncStream<PlaybackState>.Continuation!
        playbackState = AsyncStream { continuation = $0 }
        self.continuation = continuation

        timeObserver =
            player
            .addPeriodicTimeObserver(
                forInterval: CMTime(seconds: 0.25, preferredTimescale: 600),
                queue: .main
            ) { [weak player] _ in
                guard let player else { return }

                let current = player.currentTime().seconds
                let duration = player.currentItem?.duration.seconds ?? 0

                continuation
                    .yield(
                        PlaybackState(
                            currentTime: current.isFinite ? current : 0,
                            duration: duration.isFinite ? duration : 0,
                            isPlaying: player.rate > 0
                        )
                    )
            }
    }

    deinit {
        if let observer = timeObserver {
            player.removeTimeObserver(observer)
        }

        if let playbackEndObserver {
            NotificationCenter.default.removeObserver(playbackEndObserver)
        }
    }

    func play(song: Song) {
        if let playbackEndObserver {
            NotificationCenter.default.removeObserver(playbackEndObserver)
        }

        let playerItem = AVPlayerItem(url: song.previewUrl)

        playbackEndObserver = NotificationCenter.default
            .addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: playerItem,
                queue: .main
            ) { [weak self] _ in
                self?.player.seek(to: .zero)
                self?.continuation.yield(
                    PlaybackState(
                        currentTime: 0,
                        duration: playerItem.duration.seconds,
                        isPlaying: false
                    )
                )
            }

        player.replaceCurrentItem(with: playerItem)
        player.play()
    }

    func pause() { player.pause() }

    func resume() { player.play() }

    func seek(to seconds: Double) {
        let time = CMTime(seconds: seconds, preferredTimescale: 600)
        player.seek(to: time)
    }
}
