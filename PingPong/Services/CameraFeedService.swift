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
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        captureSession.addInput(input)

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(videoOutput)
    }

    func startCaptureSession() {
        captureSession.startRunning()
    }
}

extension CameraFeedService: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        onFrameCaptured?(sampleBuffer)
    }
}
