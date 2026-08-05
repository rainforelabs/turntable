//
//  AppModel.swift
//  Turntable
//
//  Created by Aditya Rohman on 05/08/26.
//

import SwiftUI

@MainActor
@Observable
final class AppModel {
    let searchModel: SearchModel
    let playerModel: PlayerModel

    init() {
        let apiService = ApiService()
        let playerService = AudioPlayerService()

        self.searchModel = SearchModel(apiService: apiService)
        self.playerModel = PlayerModel(player: playerService)
    }
}

extension View {
    func inject(_ appModel: AppModel) -> some View {
        self
            .environment(appModel.searchModel)
            .environment(appModel.playerModel)
    }
}
