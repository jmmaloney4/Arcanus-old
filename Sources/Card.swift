// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public class Card: CustomStringConvertible {
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
    }

    public enum Playability {
        case no
        case yes
        case withEffect
    }

    var name: String!
    var cost: Int!
    var cardClass: Card.Class!
    var text: String!
    internal init() {}

    public var description: String { return "\(name!) (\(cost!) Mana) [\(text!)]" }

    func playabilityForPlayer(_ player: Player) -> Playability {
        if player.mana >= cost {
            return .yes
        }
        return .no
    }
}

// MARK: - Minion
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

// MARK: - Spell
class Spell: Card {
}

class TheCoin: Spell {
    struct Constants {
        static let name = "The Coin"
        static let cost = 0
        static let cardClass = Card.Class.neutral
        static let text = "Gain 1 Mana Crystal this turn only."
    }

    public override init() {
        super.init()
        name = Constants.name
        cost = Constants.cost
        cardClass = Constants.cardClass
        text = Constants.text
    }
}

// MARK: - Weapon
class Weapon: Card {
}

class HeroPower: Card {
}

class Hero: Card {
}
