//
//  PlayerDataModel.swift
//  PingPong
//
//  Created by Dylan Lu on 10/11/24.
//

import Foundation

struct Player {
    let id: UUID
    var name: String
    var score: Int
    var handedness: PlayerHandedness
    
    enum PlayerHandedness {
        case left, right
    }

    init(name: String, handedness: PlayerHandedness) {
        self.id = UUID()
        self.name = name
        self.score = 0
        self.handedness = handedness
    }

    mutating func incrementScore() {
        score += 1
    }
    
    mutating func decrementScore() {
        score -= 1
        score = max(score, 0)
    }

    mutating func resetScore() {
        score = 0
    }
}
