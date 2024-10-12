//
//  CameraFeedService.swift
//  PingPong
//
//  Created by Dylan Lu on 10/8/24.
//

import Foundation
import AVFoundation

class CameraFeedService: NSObject, ObservableObject {
    let captureSession = AVCaptureSession()
    var onFrameCaptured: ((CMSampleBuffer) -> Void)?
    
    override init() {
        super.init()
        configureCaptureSession()
    }
    
    private func configureCaptureSession() {
        captureSession.sessionPreset = .high
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        captureSession.addInput(input)
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "com.PingPong.CameraFeedService.videoQueue"))
        captureSession.addOutput(videoOutput)
    }
    
    func startCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
}

extension CameraFeedService: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        onFrameCaptured?(sampleBuffer)
    }
}
