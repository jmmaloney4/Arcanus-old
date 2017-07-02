import Foundation

class Game {
    
    var players: [Player]
    var firstPlayer: Int!
    
    init(playerOne p1: Player, playerTwo p2: Player) {
        players = [p1, p2]
    }
    
    func start() {
        players[0].handleEvent(.gameWillStart(true))
        players[1].handleEvent(.gameWillStart(false))
        
        firstPlayer = generateRandomNumber(upTo: 1)
        players[0].handleEvent(.coinFlipped(goFirst: firstPlayer == 0))
        players[1].handleEvent(.coinFlipped(goFirst: firstPlayer == 1))
    }
}
