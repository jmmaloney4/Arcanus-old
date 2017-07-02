import Foundation

enum Event {
    /// Raised when the Game.start() method is called, indicating that a game 
    /// will be starting.
    ///
    /// The optional Bool will be set if the EventHandler recieveing this event
    /// is either player one or player two, otherwise it will remain nil.
    ///
    /// - true: This player is player one
    /// - false: This player is player two
    case gameWillStart(Bool?)
    case gameDidStart
    
    /// Raised after the coin is flipped, to let each player know whether they 
    /// are going first. This event should only be sent to the players at the 
    /// start of the game.
    ///
    /// - true: This player is going first
    /// - false: This player is going second
    case coinFlipped(goFirst: Bool)
}

protocol EventHandler {
    mutating func handleEvent(_ event: Event)
}
