import SwiftUI
import AVFoundation

struct MainPage: View {
    // TODO: Abstract this away into the viewmodel (which uses the model)
    @State private var playerAScore = 7
    @State private var playerBScore = 4
    
    var poseDetectorViewModel = PoseDetectionViewModel()
    
    var body: some View {
        ZStack {
            CameraView()
                .environmentObject(poseDetectorViewModel)
            VStack {
                HStack(spacing: 0) {
                    ScoreView(playerName: "Player A", score: $playerAScore, color: .blue)
                    ScoreView(playerName: "Player B", score: $playerBScore, color: .red)
                }
            }
        }
    }
}
