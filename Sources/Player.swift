import Foundation

protocol Player: EventHandler {
    
}

struct CLIPlayer: Player {
    var isPlayerOne: Bool
    var goFirst: Bool
    
    mutating func handleEvent(_ event: Event) {
        switch event {
        case let .coinFlipped(flipResult):
            goFirst = flipResult
            if (goFirst) {
                print("")
            }
        case let .gameWillStart(player1):
            isPlayerOne = player1!
        default:
            break
        }
    }
}
