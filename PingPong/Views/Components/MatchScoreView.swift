//
//  MatchScoreView.swift
//  PingPong
//
//  Created by Dylan Lu on 10/12/24.
//

import SwiftUI

struct MatchScoreView: View {
    
    @EnvironmentObject var matchScoreViewModel: MatchScoreViewModel
    @EnvironmentObject var matchService: MatchService
    
    // TODO: On point win, green border animation to indicate successful detection
    // TODO: Dot indicator on each player side to show that a player is detected
    
    var body: some View {
        HStack(spacing: 0) {
            PlayerScoreView(
                playerName: matchService.match.leftPlayer.name,
                playerSideOfTable: .left,
                score: matchService.match.leftPlayer.score,
                color: .red,
                onIncrementScoreClicked: matchScoreViewModel.incrementScore,
                onDecrementScoreClicked: matchScoreViewModel.decrementScore
            )
            PlayerScoreView(
                playerName: matchService.match.rightPlayer.name,
                playerSideOfTable: .right,
                score: matchService.match.rightPlayer.score,
                color: .blue,
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
        VStack(spacing: 8) {
            Spacer()
            Text(playerName)
                .font(.headline)
                .foregroundColor(.white)
            Text("\(score)")
                .font(.system(size: 180, weight: .bold))
                .foregroundColor(.white)
            HStack {
                Button() {
                    onDecrementScoreClicked(playerSideOfTable)
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundStyle(.white)
                }
                .padding(.trailing, 16)
                
                Button() {
                    onIncrementScoreClicked(playerSideOfTable)
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.8))
    }
}
