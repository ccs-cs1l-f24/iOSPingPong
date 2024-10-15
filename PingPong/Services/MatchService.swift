//
//  MatchService.swift
//  PingPong
//
//  Created by Dylan Lu on 10/12/24.
//

import Foundation
import Combine

class MatchService: ObservableObject {
    static let instance = MatchService()
    
    @Published var match: Match
    
    private init() {
        self.match = Match(leftPlayerName: "Player A", rightPlayerName: "Player B")
    }
}
