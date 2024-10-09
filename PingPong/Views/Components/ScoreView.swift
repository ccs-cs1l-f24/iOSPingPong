//
//  ScoreView.swift
//  PingPong
//
//  Created by Dylan Lu on 10/8/24.
//

import SwiftUI

struct ScoreView: View {
    var playerName: String
    @Binding var score: Int
    var color: Color

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Text(playerName)
                .font(.headline)
                .foregroundColor(.white)
            Text("\(score)")
                .font(.system(size: 128, weight: .bold))
                .foregroundColor(.white)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.6))
    }
}
