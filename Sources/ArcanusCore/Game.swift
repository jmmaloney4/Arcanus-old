// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public class Game {
    internal struct Rules {
        var cardsInDeck: Int = 30
        var startingHandSizeGoFirst: Int = 3
        var startingHandSizeGoSecond: Int = 4
        var maxManaCrystals: Int = 10
        var defaultHeroHealth: Int = 30
    }

    internal static let defaultRules = Rules()

    internal private(set) var rng: Random
    internal private(set) var players: [Player]
    internal private(set) var firstPlayer: Int!
    internal private(set) var board: Board
    internal private(set) var hasEnded: Bool
    internal private(set) var hasStarted: Bool = false
    internal private(set) var turn: Int
    private var events: [GameEvent] = []

    public init(playerOneInterface interfacePlayer1: inout PlayerInterface,
                deckPath deckPathPlayer1: String,
                playerTwoInterface interfacePlayer2: inout PlayerInterface,
                deckPath deckPathPlayer2: String)
    {
        rng = Random()
        firstPlayer = rng.next(upTo: 1)
        players = []
        board = Board()
        hasEnded = false
        turn = 0

        self.addEvent(.initGame(Game.defaultRules))

        players.append(Player(isPlayerOne: true,
                              isGoingFirst: firstPlayer == 0,
                              interface: &interfacePlayer1,
                              deckPath: deckPathPlayer1,
                              game: self))

        players.append(Player(isPlayerOne: false,
                              isGoingFirst: firstPlayer == 1,
                              interface: &interfacePlayer2,
                              deckPath: deckPathPlayer2,
                              game: self))

    }

    public func start() {
        // players[0].runMulligan()
        // players[1].runMulligan()

        hasStarted = true

        while !hasEnded {
            players[turn % 2].takeTurn(turn)
            turn += 1
        }
    }

    public var charactersInPlay: [Character] {
        get {
            var rv: [Character] = [] // [players[0].hero, players[1].hero]
            for p in players {
                for c in p.board {
                    rv.append(c)
                }
            }
            return rv
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

    // -1 so when incremented first card will have id = 0
    private var cardID = -1
    func getNextCardID() -> Int {
        cardID += 1
        return cardID
    }
}
