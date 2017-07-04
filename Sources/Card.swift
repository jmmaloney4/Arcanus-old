// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public class Card: CustomStringConvertible {
    public enum Class: CustomStringConvertible {
        case neutral
        case druid
        case hunter
        case mage
        case paladin
        case priest
        case rouge
        case shaman
        case warlock
        case warrior

        public var description: String {
            get {
                switch self {
                case .neutral: return "Neutral"
                case .druid: return "Druid"
                case .hunter: return "Hunter"
                case .mage: return "Mage"
                case .paladin: return "Paladin"
                case .priest: return "Priest"
                case .rouge: return "Rouge"
                case .shaman: return "Shaman"
                case .warlock: return "Warlock"
                case .warrior: return "Warrior"
                }
            }
        }
    }

    public enum Set {
        case basic
        case classic

        public var description: String {
            get {
                switch self {
                case .basic: return "Basic"
                case .classic: return "Classic"
                }
            }
        }
    }

    public enum Playability {
        case no
        case yes
        case withEffect
    }

    struct Constants {
        var name: String
        var cost: Int
        var cardClass: Class
        var set: Set
        var text: String

        init(name: String,
             cost: Int,
             cardClass: Class,
             set: Set,
             text: String) {
            self.name = name
            self.cost = cost
            self.cardClass = cardClass
            self.set = set
            self.text = text
        }
    }

    var name: String!
    var cost: Int!
    var cardClass: Card.Class!
    var set: Set!
    var text: String!
    internal init() {}

    public var description: String { return "\(name!) (\(cost!) Mana) [\(text!)]" }

    func playabilityForPlayer(_ player: Player) -> Playability {
        if player.mana >= cost {
            return .yes
        }
        return .no
    }

    init(constants: Constants) {
        self.name = constants.name
        self.cost = constants.cost
        self.cardClass = constants.cardClass
        self.set = constants.set
        self.text = constants.text
    }
}

// MARK: - Minion
class Minion: Card {
    public struct MinionConstants {
        var constants: Constants
        var race: Race
        var attack: Int
        var health: Int

        init(name: String,
             cost: Int,
             cardClass: Class,
             set: Set,
             text: String,
             race: Race,
             attack: Int,
             health: Int)
        {
            self.constants = Constants(name: name, cost: cost, cardClass: cardClass, set: set, text: text)
            self.race = race
            self.attack = attack
            self.health = health
        }
    }

    public enum Race {
        case neutral
        case beast

        public var description: String {
            get {
                switch self {
                case .neutral: return "Neutral"
                case .beast: return "Beast"
                }
            }
        }
    }

    var race: Race!
    var attack: Int!
    var health: Int!
    internal init(constants: MinionConstants) {
        super.init(constants: constants.constants)
        self.attack = constants.attack
        self.health = constants.health

    }
    public override var description: String { return "\(name!) (\(cost!) Mana, \(attack!)/\(health!)) [\(text!)]" }
}

class BloodfenRaptor: Minion {
    static let constants: MinionConstants = MinionConstants(name: "Bloodfen Raptor",
                                                            cost: 2,
                                                            cardClass: .neutral,
                                                            set: .basic,
                                                            text: "",
                                                            race: .neutral,
                                                            attack: 3,
                                                            health: 2)

    public init() {
        super.init(constants: BloodfenRaptor.constants)
    }
}

class KnifeJuggler: Minion {
    static let constants: MinionConstants = MinionConstants(name: "Knife Juggler",
                                                            cost: 2,
                                                            cardClass: .neutral,
                                                            set: .classic,
                                                            text: "After you summon a minion, deal 1 damage to a random enemy.",
                                                            race: .neutral,
                                                            attack: 2,
                                                            health: 2)

    public init() {
        super.init(constants: KnifeJuggler.constants)
    }
}

class StampedingKodo: Minion {
    static let constants: MinionConstants = MinionConstants(name: "Stampeding Kodo",
                                                            cost: 5,
                                                            cardClass: .neutral,
                                                            set: .classic,
                                                            text: "Battlecry: Destroy a random enemy minion with 2 or less Attack.",
                                                            race: .beast,
                                                            attack: 3,
                                                            health: 5)

    public init() {
        super.init(constants: StampedingKodo.constants)
    }
}

// MARK: - Spell
class Spell: Card {
    public struct SpellConstants {
        var constants: Constants

        init(name: String,
             cost: Int,
             cardClass: Class,
             set: Set,
             text: String)
        {
            self.constants = Constants(name: name, cost: cost, cardClass: cardClass, set: set, text: text)
        }
    }

    internal init(constants: SpellConstants) {
        super.init(constants: constants.constants)
    }
}

class TheCoin: Spell {
    static let constants = SpellConstants(name: "The Coin",
                                          cost: 0,
                                          cardClass: .neutral,
                                          set: .basic,
                                          text: "Gain 1 Mana Crystal this turn only.")

    public init() {
        super.init(constants: TheCoin.constants)
    }
}

// MARK: - Weapon
class Weapon: Card {
}

class HeroPower: Card {
}

class Hero: Card {
}
