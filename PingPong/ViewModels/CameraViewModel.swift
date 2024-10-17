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
    var scoreDetectionService: ScoreDetectionService
    
    @Published var poseOverlays: [PoseOverlay] = []
    
    init() {
        cameraFeedService = CameraFeedService()
        scoreDetectionService = ScoreDetectionService()
        
        setupPoseLandmarkerService()
        setupCameraOutputHandler()
    }
    
    private func setupPoseLandmarkerService() {
        poseLandmarkerService = PoseLandmarkerService.liveStreamPoseLandmarkerService(
            scoreDetectionDelegate: scoreDetectionService,
            poseOverlayDelegate: self
        )
    }
    
    private func setupCameraOutputHandler() {
        cameraFeedService.onFrameCaptured = { [weak self] frame in
            guard let self = self else { return }
            self.poseLandmarkerService?.detectAsync(
                sampleBuffer: frame,
                orientation: .up, // TODO: Set to actual thing
                timeStamps: Int(Date().timeIntervalSince1970 * 1000)
            )
        }
    }
    
    private func updatePoseOverlays(with landmarks: [[NormalizedLandmark]]) {
        var overlays: [PoseOverlay] = []
        
        for poseLandmarks in landmarks {
            let dots: [CGPoint] = poseLandmarks.map { CGPoint(x: CGFloat($0.x), y: CGFloat($0.y)) }
            let lines: [Line] = PoseLandmarker.poseLandmarks.map { connection in
                let start = dots[Int(connection.start)]
                let end = dots[Int(connection.end)]
                return Line(from: start, to: end)
            }
            overlays.append(PoseOverlay(dots: dots, lines: lines))
        }
        
        DispatchQueue.main.async {
            self.poseOverlays = overlays
        }
    }
    
    func startCapture() {
        cameraFeedService.startCaptureSession()
    }
}

extension CameraViewModel: PoseLandmarkerServiceLiveStreamDelegate {
    func poseLandmarkerService(_ poseLandmarkerService: PoseLandmarkerService, didFinishDetection result: ResultBundle?, error: (any Error)?) {
        guard let poseLandmarkerResult = result?.poseLandmarkerResults.first as? PoseLandmarkerResult else { return }
        self.updatePoseOverlays(with: poseLandmarkerResult.landmarks)
    }
}
