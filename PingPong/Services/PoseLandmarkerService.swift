import UIKit
import MediaPipeTasksVision
import AVFoundation
import Combine

protocol PoseLandmarkerServiceLiveStreamDelegate: AnyObject {
    func poseLandmarkerService(_ poseLandmarkerService: PoseLandmarkerService, didFinishDetection result: ResultBundle?, error: Error?)
}

class PoseLandmarkerService: NSObject {
    weak var scoreDetectionDelegate: PoseLandmarkerServiceLiveStreamDelegate?
    weak var poseOverlayDelegate: PoseLandmarkerServiceLiveStreamDelegate?
    var poseLandmarker: PoseLandmarker?
    private(set) var runningMode = RunningMode.liveStream
    private var numPoses: Int
    private var minPoseDetectionConfidence: Float
    private var minPosePresenceConfidence: Float
    private var minTrackingConfidence: Float
    private var modelPath: String
    private var delegate: PoseLandmarkerDelegate
    
    private init?(modelPath: String?,
                  runningMode: RunningMode,
                  numPoses: Int,
                  minPoseDetectionConfidence: Float,
                  minPosePresenceConfidence: Float,
                  minTrackingConfidence: Float,
                  delegate: PoseLandmarkerDelegate) {
        guard let modelPath = modelPath else { return nil }
        self.modelPath = modelPath
        self.runningMode = runningMode
        self.numPoses = numPoses
        self.minPoseDetectionConfidence = minPoseDetectionConfidence
        self.minPosePresenceConfidence = minPosePresenceConfidence
        self.minTrackingConfidence = minTrackingConfidence
        self.delegate = delegate
        super.init()
        
        createPoseLandmarker()
    }
    
    private func createPoseLandmarker() {
        let poseLandmarkerOptions = PoseLandmarkerOptions()
        poseLandmarkerOptions.runningMode = self.runningMode
        poseLandmarkerOptions.numPoses = self.numPoses
        poseLandmarkerOptions.minPoseDetectionConfidence = self.minPoseDetectionConfidence
        poseLandmarkerOptions.minPosePresenceConfidence = self.minPosePresenceConfidence
        poseLandmarkerOptions.minTrackingConfidence = self.minTrackingConfidence
        poseLandmarkerOptions.baseOptions.modelAssetPath = self.modelPath
        poseLandmarkerOptions.baseOptions.delegate = delegate.delegate
        if self.runningMode == .liveStream {
            poseLandmarkerOptions.poseLandmarkerLiveStreamDelegate = self
        }
        
        do {
            self.poseLandmarker = try PoseLandmarker(options: poseLandmarkerOptions)
        } catch {
            print(error)
        }
    }
    
    static func liveStreamPoseLandmarkerService(
        scoreDetectionDelegate: PoseLandmarkerServiceLiveStreamDelegate?,
        poseOverlayDelegate: PoseLandmarkerServiceLiveStreamDelegate?) -> PoseLandmarkerService? {
            let poseLandmarkerService = PoseLandmarkerService(
                modelPath: DefaultConstants.model.modelPath,
                runningMode: .liveStream,
                numPoses: DefaultConstants.numPoses,
                minPoseDetectionConfidence: DefaultConstants.minPoseDetectionConfidence,
                minPosePresenceConfidence: DefaultConstants.minPosePresenceConfidence,
                minTrackingConfidence: DefaultConstants.minTrackingConfidence,
                delegate: DefaultConstants.delegate)
            poseLandmarkerService?.scoreDetectionDelegate = scoreDetectionDelegate
            poseLandmarkerService?.poseOverlayDelegate = poseOverlayDelegate
            return poseLandmarkerService
        }
    
    func detectAsync(
        sampleBuffer: CMSampleBuffer,
        orientation: UIImage.Orientation,
        timeStamps: Int) {
            guard let image = try? MPImage(sampleBuffer: sampleBuffer, orientation: orientation) else {
                return
            }
            do {
                try poseLandmarker?.detectAsync(image: image, timestampInMilliseconds: timeStamps)
            } catch {
                print(error)
            }
        }
}

extension PoseLandmarkerService: PoseLandmarkerLiveStreamDelegate {
    func poseLandmarker(_ poseLandmarker: PoseLandmarker, didFinishDetection result: PoseLandmarkerResult?, timestampInMilliseconds: Int, error: (any Error)?) {
        let resultBundle = ResultBundle(
            inferenceTime: Date().timeIntervalSince1970 * 1000 - Double(timestampInMilliseconds),
            poseLandmarkerResults: [result])
        
        // Calls ScoreDetectionService
        scoreDetectionDelegate?.poseLandmarkerService(
            self,
            didFinishDetection: resultBundle,
            error: error
        )
        
        // Updates the PoseOverlay in CameraViewModel
        poseOverlayDelegate?.poseLandmarkerService(
            self,
            didFinishDetection: resultBundle,
            error: error
        )
    }
}

struct ResultBundle {
    let inferenceTime: Double
    let poseLandmarkerResults: [PoseLandmarkerResult?]
    var size: CGSize = .zero
}
