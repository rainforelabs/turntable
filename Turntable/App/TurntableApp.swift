//
//  TurntableApp.swift
//  Turntable
//
//  Created by Aditya Rohman on 05/08/26.
//

import SwiftUI

@main
struct TurntableApp: App {
    private let appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .inject(appModel)
        }
    }
}
