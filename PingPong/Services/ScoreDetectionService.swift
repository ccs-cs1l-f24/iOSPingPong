//
//  ScoreDetectionService.swift
//  PingPong
//
//  Created by Dylan Lu on 10/16/24.
//

import Foundation
import Combine
import MediaPipeTasksVision

class ScoreDetectionService: ObservableObject {
    
    var leftSidePlayer: PlayerHandDetectionService!
    var rightSidePlayer: PlayerHandDetectionService!
    
    init() {
        setupPlayers()
    }
    
    func setupPlayers() {
        leftSidePlayer = PlayerHandDetectionService(onPlayerWinsPoint: {
            DispatchQueue.main.async {
                MatchService.shared.match.playerWonPoint(sideOfTable: .left)
            }
        })
        rightSidePlayer = PlayerHandDetectionService(onPlayerWinsPoint: {
            DispatchQueue.main.async {
                MatchService.shared.match.playerWonPoint(sideOfTable: .right)
            }
        })
    }
}

extension ScoreDetectionService: PoseLandmarkerServiceLiveStreamDelegate {
    func poseLandmarkerService(_ poseLandmarkerService: PoseLandmarkerService, didFinishDetection result: ResultBundle?, error: Error?) {
        // This delegate is called by the PoseLandmarkerService delegate, which processes data then gives it to us
        // (instance of PoseLandmarkerService is created in CameraViewModel)
        guard let poseLandmarkerResult = result?.poseLandmarkerResults.first as? PoseLandmarkerResult else { return }
        
        // Should be max of two players, ideally they aren't on the same side
        for playerLandmarks in poseLandmarkerResult.landmarks {
            // Extract useful pose landmarks
            let noseLandmark = playerLandmarks[0]
            let leftWristLandmark = playerLandmarks[15]
            
            // Check which side of screen
            let isLeftSide = noseLandmark.x < 0.5
            
            // Check if raising hand
            let isRaisingHand = leftWristLandmark.y >= noseLandmark.y
            
            // Pass it to the corresponding player side hand detection service
            if isLeftSide {
                self.leftSidePlayer.update(isRaisingHand: isRaisingHand)
            }
            else {
                self.rightSidePlayer.update(isRaisingHand: isRaisingHand)
            }
        }
        
        
    }
}

class PlayerHandDetectionService {
    var handRaised: Bool = false
    var handRaiseStartTime: Date = Date.distantFuture
    var handRaiseCounted = false
    
    var onPlayerWinsPoint: () -> Void
    
    init(onPlayerWinsPoint: @escaping () -> Void) {
        self.onPlayerWinsPoint = onPlayerWinsPoint
    }
    
    func update(isRaisingHand: Bool) {
        // TODO: If we've been raising our hand long enough, give a point
        
        // Get current time
        let currentTime = Date()
        
        // If raising hand, check if we passed the threshold
        if isRaisingHand {
            // Just started raising our hand
            if !self.handRaised {
                self.handRaised = true
                self.handRaiseStartTime = currentTime
                self.handRaiseCounted = false
            }
            // We've raised our hand long enough, give a point
            else if !self.handRaiseCounted && currentTime.timeIntervalSince(self.handRaiseStartTime) >= DefaultConstants.handRaiseDurationThreshold {
                self.onPlayerWinsPoint()
                self.handRaiseCounted = true
            }
        }
        // Else, reset hand check state
        else {
            self.handRaiseStartTime = Date.distantFuture
            self.handRaised = false
            self.handRaiseCounted = false
        }
    }
}
