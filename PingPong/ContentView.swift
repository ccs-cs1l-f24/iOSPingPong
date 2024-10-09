import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var playerAScore = 7
    @State private var playerBScore = 4
    @State private var session = AVCaptureSession()
    
    var body: some View {
        ZStack {
            CameraView(session: $session)
                .ignoresSafeArea()
            VStack {
                HStack(spacing: 0) {
                    scoreView(playerName: "Player A", score: $playerAScore, color: .blue)
                    scoreView(playerName: "Player B", score: $playerBScore, color: .red)
                }
            }
        }
        .onAppear {
            configureCamera()
        }
    }
    
    private func scoreView(playerName: String, score: Binding<Int>, color: Color) -> some View {
        VStack(spacing: 16) {
            Spacer()
            Text(playerName)
                .font(.headline)
                .foregroundColor(.white)
            Text("\(score.wrappedValue)")
                .font(.system(size: 128, weight: .bold))
                .foregroundColor(.white)
            HStack {
                Button(action: {
                    if score.wrappedValue > 0 {
                        score.wrappedValue -= 1
                    }
                }) {
                    Text("-")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .padding(20)
                }
                Button(action: {
                    score.wrappedValue += 1
                }) {
                    Text("+")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .padding(20)
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.6))
    }
    
    private func configureCamera() {
        session.beginConfiguration()
        if let device = AVCaptureDevice.default(for: .video),
           let input = try? AVCaptureDeviceInput(device: device) {
            if session.canAddInput(input) {
                session.addInput(input)
            }
        }
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
        session.commitConfiguration();
        session.startRunning();
    }
}

struct CameraView: UIViewRepresentable {
    @Binding var session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            previewLayer.session = session
            previewLayer.frame = uiView.bounds
        }
    }
}

#Preview (traits: .landscapeRight){
    ContentView()
}
