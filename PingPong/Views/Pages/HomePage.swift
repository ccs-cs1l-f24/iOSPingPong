import SwiftUI

struct HomePage: View {
    @State private var playerAName = ""
    @State private var playerBName = ""
    @State private var playUntil = 11
    @State private var switchServes = 2
    @State private var handednessA = "Right"
    @State private var handednessB = "Right"
    @State private var gameHistory: [(String, String, String)] = [
        ("Dylan vs. James", "5/8/24", "11-7"),
        ("Dylan vs. James", "5/8/24", "11-7"),
        ("Dylan vs. James", "5/8/24", "11-7"),
        ("Dylan vs. James", "5/8/24", "11-7")
    ]
    
    var pointRange: [Int] = Array(1...100)
    
    var body: some View {
        NavigationStack {
            HStack(spacing: 20) {
                // Game History Section
                VStack(alignment: .leading) {
                    Text("Game History")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 8)
                    
                    ScrollView {
                        ForEach(gameHistory, id: \..0) { game in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(game.0)
                                        .font(.headline)
                                    Text(game.1)
                                        .font(.subheadline)
                                }
                                Spacer()
                                Text(game.2)
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                Button(action: {
                                    // Handle playback of game history
                                }) {
                                    Image(systemName: "play.circle.fill")
                                        .foregroundColor(.gray)
                                        .font(.title2)
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                }
                .frame(maxWidth: 300)
                .padding()
                
                Divider()
                    .frame(height: 500)
                
                // Game Settings Section
                VStack(alignment: .leading) {
                    Text("Game Settings")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 8)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Play Until")
                                    .font(.caption)
                                Picker("Reps", selection: $playUntil) {
                                    ForEach(pointRange, id: \.self) {
                                        Text("\($0)").tag($0)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: 100, height: 40)
                            }
                            VStack(alignment: .leading) {
                                Text("Switch Serves")
                                    .font(.caption)
                                Picker("Reps", selection: $switchServes) {
                                    Text("Winner").tag(-1)
                                    ForEach(pointRange, id: \.self) {
                                        Text("\($0)").tag($0)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: 100, height: 40)
                            }
                        }
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Player/Team A")
                                    .font(.caption)
                                TextField("Player A", text: $playerAName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            VStack(alignment: .leading) {
                                Text("Primary Hand")
                                    .font(.caption)
                                Picker("Primary Hand A", selection: $handednessA) {
                                    Text("Left").tag("Left")
                                    Text("Right").tag("Right")
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(width: 150)
                            }
                        }
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Player/Team B")
                                    .font(.caption)
                                TextField("Player B", text: $playerBName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            VStack(alignment: .leading) {
                                Text("Primary Hand")
                                    .font(.caption)
                                Picker("Primary Hand B", selection: $handednessB) {
                                    Text("Left").tag("Left")
                                    Text("Right").tag("Right")
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(width: 150)
                            }
                        }
                        
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: GamePage()) {
                        Text("Start New Game")
                            .font(.headline)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
            .padding()
        }
    }
}
