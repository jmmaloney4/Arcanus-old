// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

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

public protocol Minion: Character {

    var race: Race { get }

    /*
    public static func minionForName(_ name: String, withOwner owner: Player) -> Minion? {
        return Card.cardForName(name, withOwner: owner) as? Minion
    }


    internal init(constants: MinionConstants, owner: Player) {
        super.init(constants: constants.constants, owner: owner)
        self.race = constants.race
        self.attack = constants.attack
        self.health = constants.health
        self.maxHealth = constants.health
        self.armor = 0
    }

    public override var description: String {
        var rv = "\(name!) (ID: \(id)) (\(rarity.symbol), "
        if race != .neutral {
            rv.append("\(race!), ")
        }
        rv.append("\(cost!) Mana, \(attack!)/\(health!)) [\(text!)]")
        return rv
    }
     */
}

