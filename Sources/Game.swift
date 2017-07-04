// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

struct Rules {
    static let cardsInDeck: Int = 30
    static let startingHandSizeGoFirst: Int = 3
    static let startingHandSizeGoSecond: Int = 4
    static let maxManaCrystals: Int = 10
}

class Game {
    public private(set) var players: [Player]
    public private(set) var firstPlayer: Int!
    public private(set) var board: Board
    public private(set) var hasEnded: Bool
    public private(set) var turn: Int

    init(playerOneInterface interfacePlayer1: inout PlayerInterface,
         deck deckPlayer1: inout Deck,
         playerTwoInterface interfacePlayer2: inout PlayerInterface,
         deck deckPlayer2: inout Deck)
    {
        firstPlayer = generateRandomNumber(upTo: 1)
        players = []
        board = Board()
        hasEnded = false
        turn = 0
        
        players.append(Player(isPlayerOne: true,
                              isGoingFirst: firstPlayer == 0,
                              interface: &interfacePlayer1,
                              deck: &deckPlayer1,
                              game: self))

        players.append(Player(isPlayerOne: false,
                              isGoingFirst: firstPlayer == 1,
                              interface: &interfacePlayer2,
                              deck: &deckPlayer2,
                              game: self))
    }

    func start() {
        // players[0].runMulligan()
        // players[1].runMulligan()

        while !hasEnded {
            players[turn % 2].takeTurn(turn)
            turn += 1
        }
    }

    enum GameEvent {
        case playerAction(Player.Action)
    }
}
