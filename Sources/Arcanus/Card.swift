// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

internal class Card: CustomStringConvertible {
    internal enum Class: CustomStringConvertible {
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

        internal var description: String {
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

        internal var symbol: Character {
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

    internal enum Set {
        case basic
        case classic
        case oldGods

        internal var description: String {
            get {
                switch self {
                case .basic: return "Basic"
                case .classic: return "Classic"
                case .oldGods: return "Whispers of the Old Gods"
                }
            }
        }
    }

    internal enum Rarity {
        case uncollectible
        case free
        case common
        case rare
        case epic
        case legendary

        internal var description: String {
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

        internal var symbol: Character {
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

    internal enum Playability {
        case no
        case yes
        case withEffect
    }

    internal enum PlayRequirements {
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

    fileprivate static let cardIndex: [String: (Player) -> Card] = [
        // Minions

        BloodfenRaptor.constants.constants.name:{owner in BloodfenRaptor(owner: owner)},
        KnifeJuggler.constants.constants.name:{owner in KnifeJuggler(owner: owner)},
        StampedingKodo.constants.constants.name:{owner in StampedingKodo(owner: owner)},
        VioletTeacher.constants.constants.name:{owner in VioletTeacher(owner: owner)},
        VioletApprentice.constants.constants.name:{owner in VioletApprentice(owner: owner)},

        // Spells
        TheCoin.constants.constants.name:{owner in TheCoin(owner: owner)},
        Frostbolt.constants.constants.name:{owner in Frostbolt(owner: owner)},
        Cleave.constants.constants.name:{owner in Cleave(owner: owner)},
        Shatter.constants.constants.name:{owner in Shatter(owner: owner)},

        // Hero Powers
        Fireblast.constants.constants.name:{owner in Fireblast(owner: owner)}]

    internal static func cardForName(_ name: String, withOwner owner: Player) -> Card? {
        if let factoryFunc = Card.cardIndex[name] {
            return factoryFunc(owner)
        } else {
            return nil
        }
    }

    var owner: Player
    var id: Int
    var name: String!
    var cost: Int!
    var cardClass: Card.Class!
    var set: Set!
    var rarity: Rarity!
    var text: String!
    var requirements: [PlayRequirements]!

    internal var description: String { return "\(name!) (ID: \(id)) (\(cost!) Mana) [\(text!)]" }

    func playabilityForPlayer(_ player: Player) -> Playability {
        if player.mana >= cost {
            return .yes
        }
        return .no
    }

    init(constants: Constants, owner: Player) {
        self.owner = owner
        self.id = self.owner.game.getNextCardID()
        self.name = constants.name
        self.cost = constants.cost
        self.cardClass = constants.cardClass
        self.set = constants.set
        self.rarity = constants.rarity
        self.text = constants.text
    }
}

internal class Minion: Card {
    internal struct MinionConstants {
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

    internal enum Race: CustomStringConvertible {
        case neutral
        case beast

        internal var description: String {
            get {
                switch self {
                case .neutral: return "Neutral"
                case .beast: return "Beast"
                }
            }
        }
    }

    internal static func minionForName(_ name: String, withOwner owner: Player) -> Minion? {
        return Card.cardForName(name, withOwner: owner) as? Minion
    }

    var race: Race!
    var attack: Int!
    var health: Int!

    fileprivate init(constants: MinionConstants, owner: Player) {
        super.init(constants: constants.constants, owner: owner)
        self.race = constants.race
        self.attack = constants.attack
        self.health = constants.health
    }

    internal override var description: String {
        var rv = "\(name!) (ID: \(id)) (\(rarity.symbol), "
        if race != .neutral {
            rv.append("\(race!), ")
        }
        rv.append("\(cost!) Mana, \(attack!)/\(health!)) [\(text!)]")
        return rv
    }
}

class Spell: Card {
    internal struct SpellConstants {
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

    internal static func spellForName(_ name: String, withOwner owner: Player) -> Spell? {
        return Card.cardForName(name, withOwner: owner) as? Spell
    }

    fileprivate init(constants: SpellConstants, owner: Player) {
        super.init(constants: constants.constants, owner: owner)
    }
}

class Weapon: Card {
    internal struct WeaponConstants {
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

    internal static func weaponForName(_ name: String, withOwner owner: Player) -> Weapon? {
        return Card.cardForName(name, withOwner: owner) as? Weapon
    }

    internal init(constants: WeaponConstants, owner: Player) {
        super.init(constants: constants.constants, owner: owner)
    }
}

class HeroPower: Card {
    internal struct HeroPowerConstants {
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

    internal static func heroPowerForName(_ name: String, withOwner owner: Player) -> HeroPower? {
        return Card.cardForName(name, withOwner: owner) as? HeroPower
    }

    internal init(constants: HeroPowerConstants, owner: Player) {
        super.init(constants: constants.constants, owner: owner)
    }
}

class Hero: Card {
    internal struct HeroConstants {
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

    internal static func heroForName(_ name: String, withOwner owner: Player) -> Hero? {
        return Card.cardForName(name, withOwner: owner) as? Hero
    }

    internal init(constants: HeroConstants, owner: Player) {
        super.init(constants: constants.constants, owner: owner)
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

    internal init(owner: Player) {
        super.init(constants: BloodfenRaptor.constants, owner: owner)
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

    internal init(owner: Player) {
        super.init(constants: KnifeJuggler.constants, owner: owner)
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

    internal init(owner: Player) {
        super.init(constants: StampedingKodo.constants, owner: owner)
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

    internal init(owner: Player) {
        super.init(constants: VioletTeacher.constants, owner: owner)
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

    internal init(owner: Player) {
        super.init(constants: VioletApprentice.constants, owner: owner)
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

    internal init(owner: Player) {
        super.init(constants: TheCoin.constants, owner: owner)
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

    internal init(owner: Player) {
        super.init(constants: Frostbolt.constants, owner: owner)
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

    internal init(owner: Player) {
        super.init(constants: Cleave.constants, owner: owner)
    }
}

class Shatter: Spell {
    static let constants = SpellConstants(name: "Shatter",
                                          cost: 2,
                                          cardClass: .mage,
                                          set: .oldGods, rarity: .common,
                                          requirements: [.requiresFrozenTarget, .requiresMinionTarget, .requiresTargetToPlay],
                                          text: "Destroy a Frozen minion.")

    internal init(owner: Player) {
        super.init(constants: Shatter.constants, owner: owner)
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

    internal init(owner: Player) {
        super.init(constants: Fireblast.constants, owner: owner)
    }
}

