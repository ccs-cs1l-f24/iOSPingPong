//
//  MatchScoreView.swift
//  PingPong
//
//  Created by Dylan Lu on 10/12/24.
//

import SwiftUI

struct MatchScoreView: View {
    
    @EnvironmentObject var matchScoreViewModel: MatchScoreViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            PlayerScoreView(
                playerName: matchScoreViewModel.match.leftPlayer.name,
                score: matchScoreViewModel.match.leftPlayer.score,
                color: .blue
            )
            PlayerScoreView(
                playerName: matchScoreViewModel.match.rightPlayer.name,
                score: matchScoreViewModel.match.rightPlayer.score,
                color: .red)
        }
    }
}
