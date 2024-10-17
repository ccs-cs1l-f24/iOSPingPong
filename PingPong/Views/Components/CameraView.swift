//
//  CameraView.swift
//  PingPong
//
//  Created by Dylan Lu on 10/8/24.
//

import SwiftUI
import AVFoundation
import UIKit

struct CameraView: View {
    // TODO: try cameraViewModel.poseLandmakerService.detectAsync(image, timestampInMilliseconds);
    @EnvironmentObject var cameraViewModel: CameraViewModel
    
    var body: some View {
        ZStack {
            CameraPreviewView(session: cameraViewModel.cameraFeedService.captureSession)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    cameraViewModel.startCapture()
                }
            PoseOverlayView(poseOverlays: $cameraViewModel.poseOverlays)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            // Fits the camera on the screen if orientation changes?
            if let layer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
                layer.session = session
                layer.frame = uiView.bounds
                layer.connection?.videoRotationAngle = 180
            }
        }
    }
}
