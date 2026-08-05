//
//  PlayerView.swift
//  Turntable
//
//  Created by Aditya Rohman on 05/08/26.
//

import SwiftUI

struct PlayerView: View {
    @Environment(PlayerModel.self) private var playerModel
    @State private var sliderValue: Double = 0
    @State private var isDragging = false

    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Spacer()

                Button {
                    playerModel.previous()
                } label: {
                    Image(systemName: "backward.end.fill")
                        .font(.title2)
                }
                .buttonStyle(.plain)

                Spacer()

                Button {
                    playerModel.togglePlayback()
                } label: {
                    Image(
                        systemName: playerModel.isPlaying
                            ? "pause.circle.fill"
                            : "play.circle.fill"
                    )
                    .font(.largeTitle)
                }
                .disabled(playerModel.currentSong == nil)
                .buttonStyle(.plain)

                Spacer()

                Button {
                    playerModel.next()
                } label: {
                    Image(systemName: "forward.end.fill")
                        .font(.title2)
                }
                .buttonStyle(.plain)

                Spacer()
            }

            Slider(
                value: $sliderValue,
                in: 0...playerModel.duration,
                onEditingChanged: { editing in
                    isDragging = editing
                    if !editing {
                        playerModel.seek(to: sliderValue)
                    }
                }
            )
            .tint(.primary)
        }
        .padding(20)
        .onChange(of: playerModel.currentTime) {
            if !isDragging {
                sliderValue = playerModel.currentTime
            }
        }
    }
}

#Preview {
    PlayerView()
}
