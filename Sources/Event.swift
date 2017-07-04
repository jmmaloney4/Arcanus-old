// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

enum PlayerEvent {
    /*

     /// Raised when the Game.start() method is called, indicating that a game
     /// will be starting.
     ///
     /// The optional Bool will be set if the EventHandler recieveing this event
     /// is either player one or player two, otherwise it will remain nil.
     ///
     /// - true: This player is player one
     /// - false: This player is player two
     case gameWillStart(playerOne: Bool?)
     case gameDidStart

     /// Raised after the coin is flipped, to let each player know whether they
     /// are going first. This event should only be sent to the players at the
     /// start of the game.
     ///
     /// - true: This player is going first
     /// - false: This player is going second
     case coinFlipped(goFirst: Bool)

     case startingHand([Card])

     */
}

enum PlayerInterfaceEvent {
    case gameStarted
}

enum Event {
    case startingTurn(Int, by: Player)
    case endingTurn(Int, by: Player)
    case cardDrawn(Card, by: Player)
    case cardPlayed(Card, by: Player)
    

    func raise() {

    }
}
