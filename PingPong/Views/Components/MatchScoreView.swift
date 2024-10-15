//
//  MatchScoreView.swift
//  PingPong
//
//  Created by Dylan Lu on 10/12/24.
//

import SwiftUI

struct MatchScoreView: View {
    
    @EnvironmentObject var matchScoreViewModel: MatchScoreViewModel
    
    // TODO: Add buttons
    
    var body: some View {
        HStack(spacing: 0) {
            PlayerScoreView(
                playerName: matchScoreViewModel.match.leftPlayer.name,
                playerSideOfTable: .left,
                score: matchScoreViewModel.match.leftPlayer.score,
                color: .blue,
                onIncrementScoreClicked: matchScoreViewModel.incrementScore,
                onDecrementScoreClicked: matchScoreViewModel.decrementScore
            )
            PlayerScoreView(
                playerName: matchScoreViewModel.match.rightPlayer.name,
                playerSideOfTable: .right,
                score: matchScoreViewModel.match.rightPlayer.score,
                color: .red,
                onIncrementScoreClicked: matchScoreViewModel.incrementScore,
                onDecrementScoreClicked: matchScoreViewModel.decrementScore
            )
        }
    }
}

struct PlayerScoreView: View {
    var playerName: String
    var playerSideOfTable: PlayerSideOfTable
    var score: Int
    var color: Color
    
    var onIncrementScoreClicked: (PlayerSideOfTable) -> Void
    var onDecrementScoreClicked: (PlayerSideOfTable) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Text(playerName)
                .font(.headline)
                .foregroundColor(.white)
            Text("\(score)")
                .font(.system(size: 128, weight: .bold))
                .foregroundColor(.white)
            Button("Increment Score") {
                onIncrementScoreClicked(playerSideOfTable)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.8))
    }
}
