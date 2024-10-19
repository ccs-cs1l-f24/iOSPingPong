import SwiftUI
import AVFoundation

struct GamePage: View {
    
    var cameraViewModel = CameraViewModel()
    var matchScoreViewModel = MatchScoreViewModel()
    
    var body: some View {
        ZStack {
            CameraView()
                .environmentObject(cameraViewModel)
            MatchScoreView()
                .environmentObject(matchScoreViewModel)
                .environmentObject(MatchService.shared)
        }
    }
}
