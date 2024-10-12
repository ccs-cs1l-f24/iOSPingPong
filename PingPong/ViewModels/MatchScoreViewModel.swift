//
//  MatchScoreViewModel.swift
//  PingPong
//
//  Created by Dylan Lu on 10/12/24.
//

import Foundation
import Combine

class MatchScoreViewModel: ObservableObject {
    @Published var match: Match
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.match = MatchService.instance.match
        
        MatchService.instance.$match
            .receive(on: DispatchQueue.main)
            .assign(to: \ .match, on: self)
            .store(in: &cancellables)
    }
}
