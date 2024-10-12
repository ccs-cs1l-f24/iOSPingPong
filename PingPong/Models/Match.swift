//
//  Match.swift
//  PingPong
//
//  Created by Dylan Lu on 10/11/24.
//

struct Match {
    var leftPlayer: Player
    var rightPlayer: Player
    var servingPlayer: PlayerSideOfTable
    var isGameOver: Bool
    
    init(leftPlayerName: String, rightPlayerName: String) {
        self.leftPlayer = Player(name: leftPlayerName, handedness: .right)
        self.rightPlayer = Player(name: rightPlayerName, handedness: .right)
        self.servingPlayer = .left
        self.isGameOver = false
    }
    
    func getLeadingPlayer() -> PlayerSideOfTable {
        if(leftPlayer.score == rightPlayer.score) {
            return .invalid
        }
        
        if(leftPlayer.score > rightPlayer.score) {
            return .left
        }
        else {
            return .right
        }
        
    }
    
    mutating func playerWonPoint(sideOfTable: PlayerSideOfTable) {
        if(sideOfTable == .left) {
            leftPlayer.incrementScore()
        }
        else {
            rightPlayer.incrementScore()
        }
    }
    
    mutating func resetMatch() {
        leftPlayer.resetScore()
        rightPlayer.resetScore()
    }
}

enum PlayerSideOfTable {
    case left, right, invalid
}
