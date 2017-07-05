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

    public func spendMana(_ manaToSpend: Int) -> Bool {
        if self.mana < manaToSpend || manaToSpend < 0 {
            return false
        } else {
            usedMana += manaToSpend
            return true
        }
    }

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
        self.game = game
        hand = deck.startingHand(ofSize: goingFirst ? Game.defaultRules.startingHandSizeGoFirst : Game.defaultRules.startingHandSizeGoSecond)!
        board = Board()

        self.interface.player = self
        self.deck.player = self
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
                newHand.addCard(deck.draw(triggerEvent: false)!)
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
        case playCard(index: Int, location: Int?, target: Card?)
        case heroPower
        case minionCombat
        case heroCombat
        case endTurn
    }

    func playabilityOfHand() -> Card.Playability {
        var rv: Card.Playability = .no
        for card in hand {
            switch card.playabilityForPlayer(self) {
            case .yes:
                rv = .yes
            case .withEffect:
                if rv == .no {
                    rv = .withEffect
                }
            default:
                break
            }
        }
        return rv
    }

    func takeTurn(_ turn: Int) {
        if manaCrystals < Game.defaultRules.maxManaCrystals {
            manaCrystals += 1
        }
        usedMana = 0
        bonusMana = 0
        lockedMana = overloadedMana
        overloadedMana = 0

        Event.startingTurn(turn, by: self).raise()

        if let cardDrawn = deck.draw() {
            hand.addCard(cardDrawn)
        } else {
            // Fatigue
            print("Fatigue not yet implemented")
        }

        while true {
            let action = interface.nextAction()
            switch action {
            case .playCard(let index, let location, let target):
                let card = hand.removeCard(at: index)!
                if !spendMana(card.cost) {
                    assert(false, "Failed to play card \(card)")
                }

                if let minion = card as? Minion {
                    board.add(minion: minion, at: location!)
                } else if let spell = card as? Spell {
                    
                }

                break
            case .endTurn:
                Event.endingTurn(turn, by: self).raise()
                return
            default:
                break
            }
        }
    }
}

protocol PlayerInterface {
    weak var player: Player! { get set }

    func startingMulligan()
    func mulliganCard(_ card: Card) -> Bool
    func finishedMulligan()

    func nextAction() -> Player.Action

    func eventRaised(_ event: Event)
    func finishedProcessingEvent(_ event: Event)
}
