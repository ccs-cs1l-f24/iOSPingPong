//
//  MatchScoreViewModel.swift
//  PingPong
//
//  Created by Dylan Lu on 10/12/24.
//

import Foundation
import Combine
import SwiftUI

class MatchScoreViewModel: ObservableObject {
    
    init() {
        
    }
    
    func incrementScore(sideOfTable: PlayerSideOfTable) {
        MatchService.shared.match.playerWonPoint(sideOfTable: sideOfTable)
    }
    
    func decrementScore(sideOfTable: PlayerSideOfTable) {
        MatchService.shared.match.playerRemovePoint(sideOfTable: sideOfTable)
    }
}
