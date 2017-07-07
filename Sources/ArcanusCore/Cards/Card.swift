// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

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

public enum Set: CustomStringConvertible {
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

public enum PlayRequirement: Equatable {
    case requiresTargetToPlay
    case requiresMinionTarget
    case requiresFriendlyTarget
    case requiresEnemyTarget
    case requiresDamagedTarget
    case requiresFrozenTarget
    case requiresTargetWithRace(Race)
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

public protocol Targeter: Card {
    func avaliableTargets() -> [Character]
}

fileprivate let GlobalCardIndex: [String: (Player) -> Card] = [
    BloodfenRaptor.name: {BloodfenRaptor(owner: $0)},

    TheCoin.name: {TheCoin(owner: $0)},
    Frostbolt.name: {Frostbolt(owner: $0)},

    Jaina.name: {Jaina(owner: $0)}
]

public func getCardForName(_ name: String, withOwner owner: Player) -> Card? {
    if let f = GlobalCardIndex[name] {
        return f(owner)
    } else {
        return nil
    }
}

public func getMinionForName(_ name: String, withOwner owner: Player) -> Minion? {
    return getCardForName(name, withOwner: owner) as? Minion
}

public func getSpellForName(_ name: String, withOwner owner: Player) -> Spell? {
    return getCardForName(name, withOwner: owner) as? Spell
}

public func getWeaponForName(_ name: String, withOwner owner: Player) -> Weapon? {
    return getCardForName(name, withOwner: owner) as? Weapon
}

public func getHeroPowerForName(_ name: String, withOwner owner: Player) -> HeroPower? {
    return getCardForName(name, withOwner: owner) as? HeroPower
}

public func getHeroForName(_ name: String, withOwner owner: Player) -> Hero? {
    return getCardForName(name, withOwner: owner) as? Hero
}

public protocol Card: CustomStringConvertible {
    var owner: Player { get }
    var id: Int { get }
    var name: String { get }
    var text: String { get }
    var cost: Int { get }
    var cardClass: Class { get }
    var set: Set { get }
    var rarity: Rarity { get }
    var requirements: [PlayRequirement] { get }

    var playability: Playability { get }

    func hasRequirement(_ req: PlayRequirement) -> Bool
}

extension Card {
    public var description: String {
        get {
            return "\(name) (ID: \(id), owner: \(owner.goingFirst ? 1 : 2)) (\(cost) Mana) [\(text)]"
        }
    }

    public var playability: Playability {
        get {
            return owner.mana >= cost ? .yes : .no
        }
    }

    public func hasRequirement(_ req: PlayRequirement) -> Bool {
        return requirements.contains(req)
    }
}
