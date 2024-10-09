
import SwiftUI
import Foundation
import MediaPipeTasksVision

class PoseDetectionViewModel: ObservableObject {
    var poseLandmarker: PoseLandmarker?
    private(set) var runningMode = RunningMode.liveStream
    private var numPoses: Int
    private var minPoseDetectionConfidence: Float
    private var minPosePresenceConfidence: Float
    private var minTrackingConfidence: Float
    private var modelPath: String
    private var delegate: PoseLandmarkerDelegate

    // MARK: - Custom Initializer
    private init?(modelPath: String? = DefaultConstants.model.modelPath,
                  runningMode:RunningMode = RunningMode.liveStream,
                  numPoses: Int = DefaultConstants.numPoses,
                  minPoseDetectionConfidence: Float = DefaultConstants.minPoseDetectionConfidence,
                  minPosePresenceConfidence: Float = DefaultConstants.minPosePresenceConfidence,
                  minTrackingConfidence: Float = DefaultConstants.minTrackingConfidence,
                  delegate: PoseLandmarkerDelegate) {
      guard let modelPath = modelPath else { return nil }
      self.modelPath = modelPath
      self.runningMode = runningMode
      self.numPoses = numPoses
      self.minPoseDetectionConfidence = minPoseDetectionConfidence
      self.minPosePresenceConfidence = minPosePresenceConfidence
      self.minTrackingConfidence = minTrackingConfidence
      self.delegate = delegate
        

      createPoseLandmarker()
    }

    private func createPoseLandmarker() {
      let poseLandmarkerOptions = PoseLandmarkerOptions()
      poseLandmarkerOptions.runningMode = runningMode
      poseLandmarkerOptions.numPoses = numPoses
      poseLandmarkerOptions.minPoseDetectionConfidence = minPoseDetectionConfidence
      poseLandmarkerOptions.minPosePresenceConfidence = minPosePresenceConfidence
      poseLandmarkerOptions.minTrackingConfidence = minTrackingConfidence
      poseLandmarkerOptions.baseOptions.modelAssetPath = modelPath
      poseLandmarkerOptions.baseOptions.delegate = delegate.delegate
      let processor = PoseLandmarkerResultProcessor()
      poseLandmarkerOptions.poseLandmarkerLiveStreamDelegate = processor
    }
    
   
}

class PoseLandmarkerResultProcessor: NSObject, PoseLandmarkerLiveStreamDelegate {

  func poseLandmarker(
    _ poseLandmarker: PoseLandmarker,
    didFinishDetection result: PoseLandmarkerResult?,
    timestampInMilliseconds: Int,
    error: Error?) {

    // Process the pose landmarker result or errors here.

  }
}
