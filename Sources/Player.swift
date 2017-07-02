import Foundation

protocol Player: EventHandler {
    
}

struct CLIPlayer: Player {
    var isPlayerOne: Bool!
    var goFirst: Bool!
    
    /// Returns "Player One" if player one or "Player Two" if player two.
    func playerString() -> String {
        return isPlayerOne ? "Player One" : "Player Two";
    }
    
    mutating func handleEvent(_ event: Event) {
        switch event {
        case let .coinFlipped(flipResult):
            goFirst = flipResult
            if (goFirst) {
                print("\(playerString()) going first")
            } else {
                print("\(playerString()) going second")
            }
        case let .gameWillStart(player1):
            isPlayerOne = player1!
        default:
            break
        }
    }
}
