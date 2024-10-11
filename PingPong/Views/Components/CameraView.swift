//
//  CameraView.swift
//  PingPong
//
//  Created by Dylan Lu on 10/8/24.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    // TODO: try viewModel.poseLandmakerService.detectAsync(image, timestampInMilliseconds);
    @EnvironmentObject var viewModel: PoseDetectionViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                CameraPreviewView(session: viewModel.cameraFeedService.captureSession)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .onAppear {
                        viewModel.startCapture()
                    }
            }
        }
    }
}


struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let layer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            layer.session = session
            layer.frame = uiView.bounds
        }
    }
}
