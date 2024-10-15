//
//  PoseDetectionViewModel.swift
//  PingPong
//
//  Created by Dylan Lu on 10/11/24.
//

import Foundation
import AVFoundation
import MediaPipeTasksVision
import Combine

class CameraViewModel: ObservableObject {
    var cameraFeedService: CameraFeedService
    var poseLandmarkerService: PoseLandmarkerService?
    
    @Published var match: Match
    
    init() {
        self.cameraFeedService = CameraFeedService()
        self.match = MatchService.instance.match
        
        setupPoseLandmarkerService()
        setupCameraOutputHandler()
    }
    
    private func setupPoseLandmarkerService() {
        poseLandmarkerService = PoseLandmarkerService.liveStreamPoseLandmarkerService(
            modelPath: DefaultConstants.model.modelPath,
            numPoses: DefaultConstants.numPoses,
            minPoseDetectionConfidence: DefaultConstants.minPoseDetectionConfidence,
            minPosePresenceConfidence: DefaultConstants.minPosePresenceConfidence,
            minTrackingConfidence: DefaultConstants.minTrackingConfidence,
            liveStreamDelegate: self,
            delegate: DefaultConstants.delegate
        )
    }
    
    
    private func setupCameraOutputHandler() {
        cameraFeedService.onFrameCaptured = { [weak self] frame in
            guard let self = self else { return }
            self.poseLandmarkerService?.detectAsync(
                sampleBuffer: frame,
                orientation: .right, // TODO: Set to actual thing
                timeStamps: Int(Date().timeIntervalSince1970 * 1000)
            )
        }
    }
    
    func startCapture() {
        cameraFeedService.startCaptureSession()
    }
}

extension CameraViewModel: PoseLandmarkerServiceLiveStreamDelegate {
    func poseLandmarkerService(_ poseLandmarkerService: PoseLandmarkerService, didFinishDetection result: ResultBundle?, error: Error?) {
        // This delegate is called by the PoseLandmarkerService delegate, which processes data then gives it to us
        
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            guard let poseLandmarkerResult = result?.poseLandmarkerResults.first as? PoseLandmarkerResult else { return }
            // TODO: Detect hand raise on which side, depending on poseLandmarkerResult.landmarks
            
            if poseLandmarkerResult.landmarks.count >= 1 {
                // process person A, depending on their side
                print(poseLandmarkerResult.landmarks[0][15])
            }
            if poseLandmarkerResult.landmarks.count >= 2 {
                // process person B, depending on their side (not the same side)
            }
            
            
        }
    }
}
