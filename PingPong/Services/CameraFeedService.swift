//
//  CameraFeedService.swift
//  PingPong
//
//  Created by Dylan Lu on 10/8/24.
//

import Foundation
import AVFoundation


class CameraFeedService: NSObject, ObservableObject {
    // Livestream
    let captureSession = AVCaptureSession()
    var onFrameCaptured: ((CMSampleBuffer) -> Void)?
    
    // Recording game
    var assetWriter: AVAssetWriter?
    var videoInput: AVAssetWriterInput?
    var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor?
    var isRecording = false
    
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
    
    func setupAssetWriter(outputURL: URL, frameSize: CGSize) {
        do {
            assetWriter = try AVAssetWriter(outputURL: outputURL, fileType: .mov)
            
            let outputSettings: [String: Any] = [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoWidthKey: frameSize.width,
                AVVideoHeightKey: frameSize.height
            ]
            videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: outputSettings)
            
            if let assetWriter = assetWriter, let videoInput = videoInput {
                if assetWriter.canAdd(videoInput) {
                    assetWriter.add(videoInput)
                }
                
                let sourcePixelBufferAttributes: [String: Any] = [
                    kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA),
                    kCVPixelBufferWidthKey as String: frameSize.width,
                    kCVPixelBufferHeightKey as String: frameSize.height
                ]
                pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(
                    assetWriterInput: videoInput,
                    sourcePixelBufferAttributes: sourcePixelBufferAttributes
                )
            }
        } catch {
            print("Failed to set up AVAssetWriter: \(error)")
        }
    }
    
    func startRecording(outputURL: URL, frameSize: CGSize) {
        setupAssetWriter(outputURL: outputURL, frameSize: frameSize)
        assetWriter?.startWriting()
        assetWriter?.startSession(atSourceTime: CMTime.zero)
        isRecording = true
    }
    
    func stopRecording(completion: @escaping () -> Void) {
        guard isRecording else { return }
        isRecording = false
        videoInput?.markAsFinished()
        assetWriter?.finishWriting {
            print("Finished writing to file")
            completion()
        }
    }}

extension CameraFeedService: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Send to MediaPipe
        onFrameCaptured?(sampleBuffer)
        
        // Record video input
        guard isRecording, let pixelBufferAdaptor = pixelBufferAdaptor, let videoInput = videoInput, videoInput.isReadyForMoreMediaData else {
            return
        }
        
        let presentationTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
        }
            
    }
}
