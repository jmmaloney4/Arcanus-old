// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public class Minion: Card, Character {
    internal struct MinionConstants {
        var constants: Constants
        var race: Race
        var health: Int
        var attack: Int

        init(name: String,
             cost: Int,
             cardClass: Class,
             set: Set,
             rarity: Rarity,
             requirements: [PlayRequirement],
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

    public static func minionForName(_ name: String, withOwner owner: Player) -> Minion? {
        return Card.cardForName(name, withOwner: owner) as? Minion
    }

    public internal(set) var race: Race!
    public var attack: Int!
    public var health: Int!
    public var maxHealth: Int!
    public var armor: Int!

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
}

