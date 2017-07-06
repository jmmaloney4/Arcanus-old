// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public class Hero: Card, Character {
    internal struct HeroConstants {
        var constants: Constants
        var attack: Int
        var health: Int

        init(name: String,
             cost: Int,
             cardClass: Class,
             set: Set,
             rarity: Rarity,
             requirements: [PlayRequirement],
             text: String,
             attack: Int,
             health: Int)
        {
            self.constants = Constants(name: name,
                                       cost: cost,
                                       cardClass: cardClass,
                                       set: set, rarity: rarity,
                                       requirements: requirements,
                                       text: text)
            self.attack = attack
            self.health = health
        }
    }

    public var attack: Int!
    public var health: Int!
    public var maxHealth: Int!
    public var armor: Int!

    public static func heroForName(_ name: String, withOwner owner: Player) -> Hero? {
        return Card.cardForName(name, withOwner: owner) as? Hero
    }

    internal init(constants: HeroConstants, owner: Player) {
        self.attack = constants.attack
        self.health = constants.health
        self.maxHealth = constants.health
        self.armor = 0
        super.init(constants: constants.constants, owner: owner)
    }
}
