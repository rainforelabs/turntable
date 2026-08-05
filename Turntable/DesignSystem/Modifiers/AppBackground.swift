//
//  AppBackground.swift
//  Turntable
//
//  Created by Aditya Rohman on 05/08/26.
//

import SwiftUI

extension View {
    func appBackground(color: Color = .background, showPattern: Bool = true) -> some View {
        GeometryReader { proxy in
            ZStack {
                color.ignoresSafeArea()
                self
            }
        }
    }
}
