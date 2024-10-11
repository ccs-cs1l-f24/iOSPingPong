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

class PoseDetectionViewModel: ObservableObject {
    var cameraFeedService: CameraFeedService
    var poseLandmarkerService: PoseLandmarkerService?
    
    init() {
        cameraFeedService = CameraFeedService()
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
            delegate: DefaultConstants.delegate
        )
    }
    
    
    private func setupCameraOutputHandler() {
        cameraFeedService.onFrameCaptured = { [weak self] frame in
            guard let self = self else { return }
            self.poseLandmarkerService?.detectAsync(
                sampleBuffer: frame,
                orientation: .leftMirrored,
                timeStamps: Int(Date().timeIntervalSince1970 * 1000)
            )
        }
    }
    
    func startCapture() {
        cameraFeedService.startCaptureSession()
    }
}
