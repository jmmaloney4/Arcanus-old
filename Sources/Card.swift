// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

class Card: CustomStringConvertible {
    public enum Class {
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

        public func getName() -> String {
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

        public func getSymbol() -> Character {
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

    public enum Playability {
        case no
        case yes
        case withEffect

        func getSymbol() -> String {
            switch self {
            case .no:
                return "✘"
            case .yes:
                return "✔"
            case .withEffect:
                return "▶︎"
            }
        }
    }

    var name: String!
    var cost: Int!
    var cardClass: Card.Class!
    var text: String!
    internal init() {}

    public var description: String { return "\(name!) (\(cost!) Mana) [\(text!)]" }
}

class Minion: Card {
    var attack: Int!
    var health: Int!
    internal override init() {}
    public override var description: String { return "\(name!) (\(cost!) Mana, \(attack!)/\(health!)) [\(text!)]" }
}

class BloodfenRaptor: Minion {
    struct Constants {
        static let name = "Bloodfen Raptor"
        static let cost = 2
        static let cardClass = Card.Class.neutral
        static let text = ""
        static let attack = 3
        static let health = 2
    }

    public override init() {
        super.init()
        name = Constants.name
        cost = Constants.cost
        cardClass = Constants.cardClass
        text = Constants.text
        attack = Constants.attack
        health = Constants.health
    }
}

class Spell: Card {
}

class Weapon: Card {
}

class HeroPower: Card {
}

class Hero: Card {
}
