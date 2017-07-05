// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

class Game {
    struct Rules {
        var cardsInDeck: Int = 15
        var startingHandSizeGoFirst: Int = 3
        var startingHandSizeGoSecond: Int = 4
        var maxManaCrystals: Int = 10
    }

    public static let defaultRules = Rules()

    public private(set) var players: [Player]
    public private(set) var firstPlayer: Int!
    public private(set) var board: Board
    public private(set) var hasEnded: Bool
    public private(set) var hasStarted: Bool = false
    public private(set) var turn: Int
    private var events: [GameEvent] = []

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

        game.addEvent(.initGame(Game.defaultRules))

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

        hasStarted = true

        while !hasEnded {
            players[turn % 2].takeTurn(turn)
            turn += 1
        }
    }

    private func addEvent(_ event: GameEvent) {
        events.append(event)
    }

    enum GameEvent {
        case initGame(Rules)
        case initPlayer
        case playerAction(Player.Action)
    }
}
