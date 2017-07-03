// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

class Game {

    var players: [Player]
    var firstPlayer: Int!

    init(playerOneInterface interfacePlayer1: PlayerInterface,
         deck deckPlayer1: inout Deck,
         playerTwoInterface interfacePlayer2: PlayerInterface,
         deck deckPlayer2: inout Deck)
    {
        firstPlayer = generateRandomNumber(upTo: 1)
        players = []
        
        players.append(Player(isPlayerOne: true,
                              isGoingFirst: firstPlayer == 0,
                              interface: interfacePlayer1,
                              deck: &deckPlayer1))

        players.append(Player(isPlayerOne: false,
                              isGoingFirst: firstPlayer == 1,
                              interface: interfacePlayer2,
                              deck: &deckPlayer2))

    }

    func start() {
    }
}
