// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

class Player {
    public private(set) var isPlayerOne: Bool
    public private(set) var goingFirst: Bool
    public private(set) var interface: PlayerInterface
    public private(set) var deck: Deck
    public private(set) var hand: Hand
    public private(set) var board: Board

    public var mana: Int {
        get {
            var rv = manaCrystals
            rv += bonusMana
            rv -= usedMana
            rv -= lockedMana
            return rv
        }
    };
    public private(set) var usedMana: Int = 0;
    public private(set) var manaCrystals: Int = 0;
    public private(set) var bonusMana: Int = 0;
    public private(set) var lockedMana: Int = 0;
    public private(set) var overloadedMana: Int = 0;

    public weak var game: Game!;

    init(isPlayerOne: Bool,
         isGoingFirst: Bool,
         interface: inout PlayerInterface,
         deck: inout Deck,
         game: Game)
    {
        self.isPlayerOne = isPlayerOne
        goingFirst = isGoingFirst
        self.interface = interface
        self.deck = deck
        hand = deck.startingHand(ofSize: goingFirst ? Rules.startingHandSizeGoFirst : Rules.startingHandSizeGoSecond)!
        board = Board()

        self.game = game
        self.interface.player = self
    }

    /// Returns "Player One" if player one or "Player Two" if player two.
    func playerString() -> String {
        return isPlayerOne ? "Player One" : "Player Two"
    }

    func handleEvent(_ event: PlayerEvent) {
        switch event {

        default:
            break
        }
    }

    func runMulligan() {
        interface.startingMulligan()

        let newHand = Hand([])
        for c in hand {
            if interface.mulliganCard(c) {
                newHand.addCard(deck.draw()!)
                deck.shuffleIn(c)
            } else {
                newHand.addCard(c)
            }
        }

        if !goingFirst {
            newHand.addCard(TheCoin())
        }

        hand = newHand
        interface.finishedMulligan()
    }

    enum Action {
        case playCard(index: Int)
        case heroPower
        case minionCombat
        case heroCombat
        case endTurn
    }

    func takeTurn(_ turn: Int) {
        if manaCrystals < Rules.maxManaCrystals {
            manaCrystals += 1
        }
        usedMana = 0
        bonusMana = 0
        lockedMana = overloadedMana
        overloadedMana = 0

        while true {
            let action = interface.nextAction()
            switch action {
            case .playCard(let index):
                print(hand.card(at: index)!)

                break
            case .endTurn:
                return
            default:
                break
            }
        }
    }
}

protocol PlayerInterface {
    weak var player: Player! { get set }

    mutating func handleEvent(_ event: PlayerInterfaceEvent)

    func startingMulligan()
    func mulliganCard(_ card: Card) -> Bool
    func finishedMulligan()

    func optionPrompt(_ options: [String], playability: [Card.Playability]?) -> Int
    func nextAction() -> Player.Action
}
