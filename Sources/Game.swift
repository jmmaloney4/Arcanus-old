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
         deck DeckPlayer1: Deck,
         playerTwoInterface interfacePlayer2: PlayerInterface,
         deck DeckPlayer2: Deck)
    {
        firstPlayer = generateRandomNumber(upTo: 1)
        players = []
    }

    func start() {
    }
}
