import SwiftUI

let actions = ["X", "O"]

var cells = [CellState(),CellState(),CellState(),
             CellState(),CellState(),CellState(),
             CellState(),CellState(),CellState()
]

var actionQueue : [Int] = []
var remove_item = -1

struct GameView: View {
    @State private var player = 1
    @State private var player_color = Color.red
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            ZStack{
                Color.cyan
                    .ignoresSafeArea(.all)
                VStack {
                    PlayerInfoView(player: $player, playerColor: $player_color)
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            CellView(index: 0, cellState: cells[0], player: $player, playerColor: $player_color, showAlert: $showAlert)
                            CellView(index: 1, cellState: cells[1], player: $player, playerColor: $player_color, showAlert: $showAlert)
                            CellView(index: 2, cellState: cells[2], player: $player, playerColor: $player_color, showAlert: $showAlert)
                        }
                        HStack(spacing: 0) {
                            CellView(index: 3, cellState: cells[3], player: $player, playerColor: $player_color, showAlert: $showAlert)
                            CellView(index: 4, cellState: cells[4], player: $player, playerColor: $player_color, showAlert: $showAlert)
                            CellView(index: 5, cellState: cells[5], player: $player, playerColor: $player_color, showAlert: $showAlert)
                        }
                        HStack(spacing: 0) {
                            CellView(index: 6, cellState: cells[6], player: $player, playerColor: $player_color, showAlert: $showAlert)
                            CellView(index: 7, cellState: cells[7], player: $player, playerColor: $player_color, showAlert: $showAlert)
                            CellView(index: 8, cellState: cells[8], player: $player, playerColor: $player_color, showAlert: $showAlert)
                        }
                    }
                    .border(Color.cyan, width: 4)
                    .padding()
                    HStack{
                        Button(action: {
                            resetGame(player: $player, playerColor: $player_color)
                        }){
                            Text("Reset")
                                .font(.system(size: 15))
                                .foregroundColor(.black)
                                .frame(width: 40, height: 10)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(5)
                        }
                    }
                    .padding()
                }
                

            }
        }
    }
}

struct PlayerInfoView: View {
    @Binding var player: Int
    @Binding var playerColor: Color
    
    var body: some View {
        HStack{
            Text("Player ")
                .font(.system(size: 30))
                .bold()
                .foregroundColor(.black)
            Text("\(player)")
                .font(.system(size: 40))
                .bold()
                .underline()
                .foregroundColor(playerColor)
        }
    }
}

struct CellView: View {
    let index: Int
    @ObservedObject var cellState: CellState
    @Binding var player: Int
    @Binding var playerColor: Color
    @Binding var showAlert: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                applyAction(index: index, player: $player, playerColor: $playerColor, cellState: cellState, showAlert:$showAlert)
            }){
                Text("\(cellState.sign)")
                    .font(.title)
                    .bold()
                    .frame(width: 100, height: 100)
                    .background(Color.cyan)
                    .foregroundColor(cellState.playerColor)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 3)
                    .disabled(cellState.hasBeenTapped)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("🏆"),
                    message: Text("Player \(player % 2 + 1) won 🎉"),
                    dismissButton: .default(Text("Start Over!"), action: {
                        resetGame(player: $player, playerColor: $playerColor)
                    })
                )
            }
        }
    }
}

class CellState: ObservableObject {
    @Published var sign: String = ""
    @Published var hasBeenTapped: Bool = false
    @Published var playerColor: Color = .clear
}

func resetGame(player: Binding<Int>, playerColor: Binding<Color>){
    for i in cells{
        i.sign = ""
        i.playerColor = .clear
        i.hasBeenTapped = false
    }
    
    actionQueue.removeAll()
    
    player.wrappedValue = 1
    playerColor.wrappedValue = Color.red
    
    delay()
    delay()
}

func applyAction(index: Int, player: Binding<Int>, playerColor: Binding<Color>, cellState: CellState, showAlert: Binding<Bool>) {
    if !cellState.hasBeenTapped {
        
        if (remove_item != -1){
            cells[remove_item].sign = ""
            cells[remove_item].playerColor = .clear
            cells[remove_item].hasBeenTapped = false
            remove_item = -1
            actionQueue.removeFirst()
        }
        
        if player.wrappedValue == 1 {
            cells[index].sign = actions[player.wrappedValue - 1]
            cells[index].playerColor = Color.red
            player.wrappedValue = 2
            playerColor.wrappedValue = Color.yellow
        } else {
            cells[index].sign = actions[player.wrappedValue - 1]
            cells[index].playerColor = Color.yellow
            player.wrappedValue = 1
            playerColor.wrappedValue = Color.red
        }
        cellState.hasBeenTapped = true
        showAlert.wrappedValue = isFinish()
        actionQueue.append(index)
        
        if (actionQueue.count > 5){
            let fade_item = actionQueue[0]
            cells[fade_item].playerColor = .gray
            remove_item = fade_item
        }
    }
}

func isFinish() -> Bool{
    if (cells[0].sign == cells[1].sign && cells[1].sign == cells[2].sign && cells[1].sign != ""){
        delay()
        return true
    } else if (cells[3].sign == cells[4].sign && cells[4].sign == cells[5].sign && cells[4].sign != ""){

        delay()
        return true
    }  else if (cells[6].sign == cells[7].sign && cells[7].sign == cells[8].sign && cells[7].sign != ""){

        delay()
        return true
    }   else if (cells[0].sign == cells[3].sign && cells[3].sign == cells[6].sign && cells[3].sign != ""){

        delay()
        return true
    }   else if (cells[1].sign == cells[4].sign && cells[4].sign == cells[7].sign && cells[4].sign != ""){

        delay()
        return true
    }   else if (cells[2].sign == cells[5].sign && cells[5].sign == cells[8].sign && cells[5].sign != ""){

        delay()
        return true
    }    else if (cells[0].sign == cells[4].sign && cells[4].sign == cells[8].sign && cells[4].sign != ""){

        delay()
        return true
    }    else if (cells[2].sign == cells[4].sign && cells[4].sign == cells[6].sign && cells[4].sign != ""){

        delay()
        return true
    }
    return false
}

func delay(){
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
    }
}



#Preview {
    GameView()
}
