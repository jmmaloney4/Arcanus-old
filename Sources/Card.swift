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

        public var symbol: Character {
            get {
                switch self {
                case .neutral: return "¤"
                case .druid: return "🌿"
                case .hunter: return "🏹"
                case .mage: return "🔥"
                case .paladin: return "🔨"
                case .priest: return "✜"
                case .rouge: return "⚔️"
                case .shaman: return "🌋"
                case .warlock: return "🖐️"
                case .warrior: return "🗡"
                }
            }

        }
    }

    public enum Set {
        case basic
        case classic
        case oldGods

        public var description: String {
            get {
                switch self {
                case .basic: return "Basic"
                case .classic: return "Classic"
                case .oldGods: return "Whispers of the Old Gods"
                }
            }
        }
    }

    public enum Rarity {
        case uncollectible
        case free
        case common
        case rare
        case epic
        case legendary

        public var description: String {
            get {
                switch self {
                case .uncollectible: return "Uncollectible"
                case .free: return "Free"
                case .common: return "Common"
                case .rare: return "Rare"
                case .epic: return "Epic"
                case .legendary : return "Legendary"
                }
            }
        }

        public var symbol: Character {
            get {
                switch self {
                case .uncollectible: return "🚫"
                case .free: return "🆓"
                case .common: return "🖤"
                case .rare: return "💙"
                case .epic: return "💜"
                case .legendary: return "💛"
                }
            }
        }
    }

    public enum Playability {
        case no
        case yes
        case withEffect
    }

    public enum PlayRequirements {
        case requiresTargetToPlay
        case requiresMinionTarget
        case requiresFriendlyTarget
        case requiresEnemyTarget
        case requiresDamagedTarget
        case requiresFrozenTarget
        case requiresTargetWithRace(Minion.Race)
        case requiresMinEnemyMinions(Int)
    }

    struct Constants {
        var name: String
        var cost: Int
        var cardClass: Class
        var set: Set
        var rarity: Rarity
        var requirements: [PlayRequirements]
        var text: String

        init(name: String,
             cost: Int,
             cardClass: Class,
             set: Set,
             rarity: Rarity,
             requirements: [PlayRequirements],
             text: String) {
            self.name = name
            self.cost = cost
            self.cardClass = cardClass
            self.set = set
            self.rarity = rarity
            self.requirements = requirements
            self.text = text
        }
    }

    fileprivate static let cardIndex: [String: () -> Card] = [
        // Minions
        BloodfenRaptor.constants.constants.name:{BloodfenRaptor()},
        KnifeJuggler.constants.constants.name:{KnifeJuggler()},
        StampedingKodo.constants.constants.name:{StampedingKodo()},
        VioletTeacher.constants.constants.name:{VioletTeacher()},
        VioletApprentice.constants.constants.name:{VioletApprentice()},

        // Spells
        TheCoin.constants.constants.name:{TheCoin()},
        Frostbolt.constants.constants.name:{Frostbolt()},
        Cleave.constants.constants.name:{Cleave()},
        Shatter.constants.constants.name:{Shatter()},

        Fireblast.constants.constants.name:{Fireblast()}]

    fileprivate static func cardForName(_ name: String) -> Card? {
        if let factoryFunc = Card.cardIndex[name] {
            return factoryFunc()
        } else {
            return nil
        }
    }

    var name: String!
    var cost: Int!
    var cardClass: Card.Class!
    var set: Set!
    var rarity: Rarity!
    var text: String!
    var requirements: [PlayRequirements]!

    public var description: String { return "\(name) (\(cost) Mana) [\(text)]" }

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
        self.rarity = constants.rarity
        self.text = constants.text
    }
}

public class Minion: Card {
    public struct MinionConstants {
        var constants: Constants
        var race: Race
        var attack: Int
        var health: Int

        init(name: String,
             cost: Int,
             cardClass: Class,
             set: Set,
             rarity: Rarity,
             requirements: [PlayRequirements],
             text: String,
             race: Race,
             attack: Int,
             health: Int)
        {
            self.constants = Constants(name: name,
                                       cost: cost,
                                       cardClass: cardClass,
                                       set: set,
                                       rarity: rarity,
                                       requirements: requirements,
                                       text: text)
            self.race = race
            self.attack = attack
            self.health = health
        }
    }

    public enum Race: CustomStringConvertible {
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
    fileprivate init(constants: MinionConstants) {
        super.init(constants: constants.constants)
        self.race = constants.race
        self.attack = constants.attack
        self.health = constants.health

    }
    public override var description: String {
        var rv = "\(name!) (\(rarity.symbol), "
        if race != .neutral {
            rv.append("\(race!), ")
        }
        rv.append("\(cost!) Mana, \(attack!)/\(health!)) [\(text!)]")
        return rv
    }
}

class Spell: Card {
    public struct SpellConstants {
        var constants: Constants

        init(name: String,
             cost: Int,
             cardClass: Class,
             set: Set,
             rarity: Rarity,
             requirements: [PlayRequirements],
             text: String)
        {
            self.constants = Constants(name: name,
                                       cost: cost,
                                       cardClass: cardClass,
                                       set: set,
                                       rarity: rarity,
                                       requirements: requirements,
                                       text: text)
        }
    }

    public static func spellForName(_ name: String) -> Spell? {
        return Card.cardForName(name) as? Spell
    }

    fileprivate init(constants: SpellConstants) {
        super.init(constants: constants.constants)
    }
}

class Weapon: Card {
    public struct WeaponConstants {
        var constants: Constants

        init(name: String,
             cost: Int,
             cardClass: Class,
             set: Set,
             rarity: Rarity,
             requirements: [PlayRequirements],
             text: String)
        {
            self.constants = Constants(name: name,
                                       cost: cost,
                                       cardClass: cardClass,
                                       set: set,
                                       rarity: rarity,
                                       requirements: requirements,
                                       text: text)
        }
    }

    public static func weaponForName(_ name: String) -> Weapon? {
        return Card.cardForName(name) as? Weapon
    }

    internal init(constants: WeaponConstants) {
        super.init(constants: constants.constants)
    }
}

class HeroPower: Card {
    public struct HeroPowerConstants {
        var constants: Constants

        init(name: String,
             cost: Int,
             cardClass: Class,
             set: Set,
             rarity: Rarity,
             requirements: [PlayRequirements],
             text: String)
        {
            self.constants = Constants(name: name,
                                       cost: cost,
                                       cardClass: cardClass,
                                       set: set,
                                       rarity: rarity,
                                       requirements: requirements,
                                       text: text)
        }
    }

    public static func heroPowerForName(_ name: String) -> HeroPower? {
        return Card.cardForName(name) as? HeroPower
    }

    internal init(constants: HeroPowerConstants) {
        super.init(constants: constants.constants)
    }
}

class Hero: Card {
    public struct HeroConstants {
        var constants: Constants

        init(name: String,
             cost: Int,
             cardClass: Class,
             set: Set,
             rarity: Rarity,
             requirements: [PlayRequirements],
             text: String)
        {
            self.constants = Constants(name: name,
                                       cost: cost,
                                       cardClass: cardClass,
                                       set: set, rarity: rarity,
                                       requirements: requirements,
                                       text: text)
        }
    }

    public static func heroForName(_ name: String) -> Hero? {
        return Card.cardForName(name) as? Hero
    }

    internal init(constants: HeroConstants) {
        super.init(constants: constants.constants)
    }
}

// ----------------------------------------------------------------------------
//
// MARK: - Definitions
//
// ----------------------------------------------------------------------------

// MARK: - Minion
class BloodfenRaptor: Minion {
    static let constants: MinionConstants = MinionConstants(name: "Bloodfen Raptor",
                                                            cost: 2,
                                                            cardClass: .neutral,
                                                            set: .basic,
                                                            rarity: .free,
                                                            requirements: [],
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
                                                            rarity: .rare,
                                                            requirements: [],
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
                                                            rarity: .rare,
                                                            requirements: [],
                                                            text: "Battlecry: Destroy a random enemy minion with 2 or less Attack.",
                                                            race: .beast,
                                                            attack: 3,
                                                            health: 5)

    public init() {
        super.init(constants: StampedingKodo.constants)
    }
}

class VioletTeacher: Minion {
    static let constants: MinionConstants = MinionConstants(name: "Violet Teacher",
                                                            cost: 4,
                                                            cardClass: .neutral,
                                                            set: .classic,
                                                            rarity: .rare,
                                                            requirements: [],
                                                            text: "Whenever you cast a spell, summon a 1/1 Violet Apprentice.",
                                                            race: .neutral,
                                                            attack: 3,
                                                            health: 5)

    public init() {
        super.init(constants: VioletTeacher.constants)
    }
}

class VioletApprentice: Minion {
    static let constants: MinionConstants = MinionConstants(name: "Violet Apprentice",
                                                            cost: 1,
                                                            cardClass: .neutral,
                                                            set: .classic, rarity: .uncollectible,
                                                            requirements: [],
                                                            text: "",
                                                            race: .neutral,
                                                            attack: 1,
                                                            health: 1)

    public init() {
        super.init(constants: VioletApprentice.constants)
    }
}

// MARK: - Spell
class TheCoin: Spell {
    static let constants = SpellConstants(name: "The Coin",
                                          cost: 0,
                                          cardClass: .neutral,
                                          set: .basic,
                                          rarity: .uncollectible,
                                          requirements: [],
                                          text: "Gain 1 Mana Crystal this turn only.")

    public init() {
        super.init(constants: TheCoin.constants)
    }
}

class Frostbolt: Spell {
    static let constants = SpellConstants(name: "Frostbolt",
                                          cost: 3,
                                          cardClass: .mage,
                                          set: .basic,
                                          rarity: .free,
                                          requirements: [.requiresTargetToPlay],
                                          text: "Deal 3 damage to a character and Freeze it.")

    public init() {
        super.init(constants: Frostbolt.constants)
    }
}

class Cleave: Spell {
    static let constants = SpellConstants(name: "Cleave",
                                          cost: 2,
                                          cardClass: .warrior,
                                          set: .basic,
                                          rarity: .free,
                                          requirements: [.requiresMinEnemyMinions(2)],
                                          text: "Deal 2 damage to two random enemy minions.")

    public init() {
        super.init(constants: Cleave.constants)
    }
}

class Shatter: Spell {
    static let constants = SpellConstants(name: "Shatter",
                                          cost: 2,
                                          cardClass: .mage,
                                          set: .oldGods, rarity: .common,
                                          requirements: [.requiresFrozenTarget, .requiresMinionTarget, .requiresTargetToPlay],
                                          text: "Destroy a Frozen minion.")

    public init() {
        super.init(constants: Shatter.constants)
    }
}

// MARK: - Weapon

// MARK: - HeroPower
class Fireblast: HeroPower {
    static let constants = HeroPowerConstants(name: "Fireblast",
                                              cost: 2,
                                              cardClass: .mage,
                                              set: .basic,
                                              rarity: .uncollectible,
                                              requirements: [.requiresTargetToPlay],
                                              text: "Deal 1 damage.")

    public init() {
        super.init(constants: Fireblast.constants)
    }
}

