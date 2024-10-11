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

    init(name: String) {
        self.id = UUID()
        self.name = name
        self.score = 0
    }

    mutating func incrementScore() {
        score += 1
    }

    mutating func resetScore() {
        score = 0
    }
}
