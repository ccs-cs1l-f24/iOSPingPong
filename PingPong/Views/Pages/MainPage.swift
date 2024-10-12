import SwiftUI
import AVFoundation

struct MainPage: View {
    var cameraViewModel = CameraViewModel()
    var matchScoreViewModel = MatchScoreViewModel()
    
    var body: some View {
        ZStack {
            CameraView()
                .environmentObject(cameraViewModel)
            //MatchScoreView()
              //  .environmentObject(matchScoreViewModel)
        }
    }
}
