// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public protocol Character {
    var attack: Int! { get set }
    var health: Int! { get set }
    var maxHealth: Int! { get set }
    var armor: Int! { get set }

    // var isDead: Bool { get }
}

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

        public var symbol: Swift.Character {
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

    public enum Set:CustomStringConvertible {
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

    public enum Rarity: CustomStringConvertible {
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

        public var symbol: Swift.Character {
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

    public enum PlayRequirement {
        case requiresTargetToPlay
        case requiresMinionTarget
        case requiresFriendlyTarget
        case requiresEnemyTarget
        case requiresDamagedTarget
        case requiresFrozenTarget
        case requiresTargetWithRace(Minion.Race)
        case requiresMinEnemyMinions(Int)

        public static func ==(lhs: PlayRequirement, rhs: PlayRequirement) -> Bool {
            switch (lhs, rhs) {
            case (.requiresTargetWithRace(let a), .requiresTargetWithRace(let b)):
                return a == b
            case (.requiresMinEnemyMinions(let a), .requiresMinEnemyMinions(let b)):
                return a == b
            case (.requiresTargetToPlay, .requiresTargetToPlay),
                 (.requiresMinionTarget, .requiresMinionTarget),
                 (.requiresFriendlyTarget, .requiresFriendlyTarget),
                 (.requiresEnemyTarget, .requiresEnemyTarget),
                 (.requiresDamagedTarget, .requiresDamagedTarget),
                 (.requiresFrozenTarget, .requiresFrozenTarget):
                return true
            default:
                return false
            }
        }
    }

    internal struct Constants {
        var name: String
        var cost: Int
        var cardClass: Class
        var set: Set
        var rarity: Rarity
        var requirements: [PlayRequirement]
        var text: String

        init(name: String,
             cost: Int,
             cardClass: Class,
             set: Set,
             rarity: Rarity,
             requirements: [PlayRequirement],
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

    internal static let cardIndex: [String: (Player) -> Card] = [
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
        Fireblast.constants.constants.name:{owner in Fireblast(owner: owner)},

        // Heros
        Jaina.constants.constants.name:{owner in Jaina(owner: owner)}]

    public static func cardForName(_ name: String, withOwner owner: Player) -> Card? {
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
    var requirements: [PlayRequirement]!

    public var description: String { return "\(name!) (ID: \(id)) (\(cost!) Mana) [\(text!)]" }

    func playabilityForPlayer(_ player: Player) -> Playability {
        if player.mana >= cost {
            return .yes
        }
        return .no
    }

    internal init(constants: Constants, owner: Player) {
        self.owner = owner
        self.id = self.owner.game.getNextCardID()
        self.name = constants.name
        self.cost = constants.cost
        self.cardClass = constants.cardClass
        self.set = constants.set
        self.rarity = constants.rarity
        self.text = constants.text
        self.requirements = constants.requirements
    }

    public func hasRequirement(_ req: PlayRequirement) -> Bool {
        return self.requirements.contains(where: {$0 == req})
    }
}
