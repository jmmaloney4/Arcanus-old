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
    internal private(set) var hero: Hero!
    internal var enemy: Player {
        get {
            if isPlayerOne {
                return game.players[1]
            } else {
                return game.players[0]
            }
        }
    }

    internal func ownedCharacters() -> [Character] {
        var rv: [Character] = [hero]
        for c in board {
            rv.append(c)
        }
        return rv
    }

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
         game: Game) throws
    {
        self.isPlayerOne = isPlayerOne
        goingFirst = isGoingFirst
        self.interface = interface
        board = Board()
        self.game = game

        self.hero = getDefaultHeroForClass(isPlayerOne ? .mage : .rouge, owner: self)!
        do {
            self.deck = try Deck(cards: Array(repeatElement(BloodfenRaptor(owner: self), count: game.rules.cardsInDeck)), player: self)
            self.deck = try Deck(deckstring: deck.getDeckstring(), player: self)
        } catch {
            throw error
        }
        
        hand = deck.startingHand(ofSize: goingFirst ? game.rules.startingHandSizeGoFirst : game.rules.startingHandSizeGoSecond)!

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
        case playCard
        case heroPower
        case combat
        case endTurn
    }

    func takeTurn(_ turn: Int) {
        interface.startingTurn(turn)
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
            case .playCard:
                let index = interface.whichCardToPlay()
                let card = hand.removeCard(at: index)!
                if !spendMana(card.cost) {
                    interface.error(.notEnoughMana)
                    continue;
                }

                if let minion = card as? Minion {
                    let location = interface.whereToPlayMinion(minion)
                    if let targeter = minion as? Targeter {
                        print("Targets: \(targeter.avaliableTargets())")
                    }

                    board.insert(minion, at: location)
                } else if let spell = card as? Spell {
                    print("Cast \(spell)")
                    var target: Character? = nil
                    if let targeter = spell as? Targeter {
                        target = interface.selectTarget(targeter.avaliableTargets())
                    }
                    try! spell.executeSpellText(onTarget: target)
                }

            case .heroPower:
                if !spendMana(self.hero.heroPower.cost) {
                    interface.error(.notEnoughMana)
                    continue;
                }
                
                var target: Character? = nil
                if let targeter = self.hero.heroPower as? Targeter {
                    target = interface.selectTarget(targeter.avaliableTargets())
                }
                try! self.hero.heroPower.executeHeroPowerText(onTarget: target)
                break
                
            case .combat:
                let attacker = interface.characterToAttackWith(ownedCharacters())
                let target = interface.characterToAttack(enemy.ownedCharacters())

                attacker.attack(target)

                break
            case .endTurn:
                return
            }
        }
    }
}

public protocol PlayerInterface {
    weak var player: Player! { get set }

    func error(_ err: ARError)

    func startingMulligan()
    func mulliganCard(_ card: Card) -> Bool
    func finishedMulligan()
    
    func startingTurn(_ turn: Int)
    func nextAction() -> Player.Action
    func whichCardToPlay() -> Int
    func whereToPlayMinion(_ minion: Minion) -> Int
    func selectTarget(_ targets: [Character]) -> Character
    func characterToAttackWith(_ canAttack: [Character]) -> Character
    func characterToAttack(_ possibleTargets: [Character]) -> Character
}
