//
//  MatchService.swift
//  PingPong
//
//  Created by Dylan Lu on 10/12/24.
//

import Foundation
import Combine

class MatchService: ObservableObject {
    static let shared = MatchService()
    @Published var match: Match = Match(leftPlayerName: "Player A", rightPlayerName: "Player B")
    
    private init() {}
}
