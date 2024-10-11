//
//  Match.swift
//  PingPong
//
//  Created by Dylan Lu on 10/11/24.
//


struct Match {
    var player1: Player
    var player2: Player

    init(player1Name: String, player2Name: String) {
        self.player1 = Player(name: player1Name)
        self.player2 = Player(name: player2Name)
    }

    func getLeadingPlayer() -> Player? {
        if player1.score > player2.score {
            return player1
        } else if player2.score > player1.score {
            return player2
        } else {
            return nil  // It's a tie
        }
    }

    mutating func resetMatch() {
        player1.resetScore()
        player2.resetScore()
    }
}
