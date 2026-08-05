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

    var body: some View {
        Group {
            switch searchModel.status {
            case .idle:
                EmptyView()
            case .searching:
                ProgressView("Searching")
                    .progressViewStyle(CircularProgressViewStyle(tint: .red))
                    .scaleEffect(1.2)
            case .found(let songs):
                SongListView(songs: songs)
            case .failure(let error):
                Text(error.localizedDescription)
            }
        }
        .appBackground()
        .onAppear { searchModel.search(for: "hindia") }
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
            // if playerModel.currentSong != nil {
                PlayerView()
            // }
        }
    }
}

#Preview {
    HomeView()
        .inject(AppModel())
}
