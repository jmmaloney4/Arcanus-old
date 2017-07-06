// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public class Player {
    internal private(set) var isPlayerOne: Bool
    internal private(set) var goingFirst: Bool
    internal private(set) var interface: PlayerInterface
    internal private(set) var deck: Deck!
    internal private(set) var hand: Hand!
    internal private(set) var board: Board

    internal var mana: Int {
        get {
            var rv = manaCrystals
            rv += bonusMana
            rv -= usedMana
            rv -= lockedMana
            return rv
        }
    };
    internal private(set) var usedMana: Int = 0;
    internal private(set) var manaCrystals: Int = 0;
    internal private(set) var bonusMana: Int = 0;
    internal private(set) var lockedMana: Int = 0;
    internal private(set) var overloadedMana: Int = 0;

    internal func spendMana(_ manaToSpend: Int) -> Bool {
        if self.mana < manaToSpend || manaToSpend < 0 {
            return false
        } else {
            usedMana += manaToSpend
            return true
        }
    }

    internal weak var game: Game!;

    init(isPlayerOne: Bool,
         isGoingFirst: Bool,
         interface: inout PlayerInterface,
         deckPath: String,
         game: Game)
    {
        self.isPlayerOne = isPlayerOne
        goingFirst = isGoingFirst
        self.interface = interface
        board = Board()
        self.game = game
        self.deck = Deck(path: deckPath, player: self)!
        hand = deck.startingHand(ofSize: goingFirst ? Game.defaultRules.startingHandSizeGoFirst : Game.defaultRules.startingHandSizeGoSecond)!

        self.interface.player = self
        self.deck.player = self
    }

    /// Returns "Player One" if player one or "Player Two" if player two.
    func playerString() -> String {
        return isPlayerOne ? "Player One" : "Player Two"
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
            newHand.addCard(TheCoin(owner: self))
        }

        hand = newHand
        interface.finishedMulligan()
    }

    public enum Action {
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
                return
            default:
                break
            }
        }
    }
}

public protocol PlayerInterface {
    weak var player: Player! { get set }

    func startingMulligan()
    func mulliganCard(_ card: Card) -> Bool
    func finishedMulligan()

    func nextAction() -> Player.Action
}
