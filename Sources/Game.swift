import Foundation

class Game {
    
    var players: [Player]
   
    init(playerOne p1: Player, playerTwo p2: Player) {
        players = [p1, p2]
    }
    
    func start() {
        players[0].handleEvent(.gameWillStart(true))
        players[1].handleEvent(.gameWillStart(false))
        
        
    }

    
}
