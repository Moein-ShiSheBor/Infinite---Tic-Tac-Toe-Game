import SwiftUI

struct ContentView: View {
    @State private var isGameActive = false
    
    @State private var displayText = ""
    private let text = "  By:  MooNice  "
    @State private var currentIndex = 0
    @State private var timer: Timer?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.cyan
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("∞")
                        .font(.system(size: 200))
                        .foregroundColor(.yellow)
                    Text("Tic Tac Toe")
                        .font(.system(size: 60))
                        .bold()
                        .foregroundColor(.yellow)
                    
                    NavigationLink(value: isGameActive) {
                        Button(action: {
                            startGame()
                        }) {
                            Text("Start")
                                .font(.system(size: 36))
                                .foregroundColor(.white)
                                .frame(width: 200, height: 50)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(20)
                        }
                        .padding()
                    }
                    .navigationDestination(isPresented: $isGameActive) {
                        GameView()
                    }
                    
                    Text(displayText)
                        .font(.system(size: 20))
                        .padding()
                        .foregroundColor(.green)
                        .background(Color.black)
                        .cornerRadius(10)
                        .onAppear {
                            startTimer()
                        }
                        .padding()
                }
                .padding()
            }
        }
    }
    
    private func startGame() {
        isGameActive = true
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.19, repeats: true) { _ in
            updateText()
        }
    }
    
    private func updateText() {
        if currentIndex < text.count {
            currentIndex += 1
        } else {
            currentIndex = 1
            displayText = ""
        }
        
        displayText = String(text.prefix(currentIndex))
    }
}

#Preview {
    ContentView()
}
