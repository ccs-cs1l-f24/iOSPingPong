import SwiftUI
import AVFoundation

struct MainPage: View {
    @State private var playerAScore = 7
    @State private var playerBScore = 4
    
    
    var body: some View {
        ZStack {
            CameraView()
                .environmentObject(PoseDetectionViewModel())
            VStack {
                HStack(spacing: 0) {
                    ScoreView(playerName: "Player A", score: $playerAScore, color: .blue)
                    ScoreView(playerName: "Player B", score: $playerBScore, color: .red)
                }
            }
        }
    }
}
#Preview (traits: .landscapeRight){
    MainPage()
}
