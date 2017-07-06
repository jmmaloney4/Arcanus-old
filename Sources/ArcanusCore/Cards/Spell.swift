// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public class Spell: Card {
    internal struct SpellConstants {
        var constants: Constants

        init(name: String,
             cost: Int,
             cardClass: Class,
             set: Set,
             rarity: Rarity,
             requirements: [PlayRequirement],
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

    public static func spellForName(_ name: String, withOwner owner: Player) -> Spell? {
        return Card.cardForName(name, withOwner: owner) as? Spell
    }

    internal init(constants: SpellConstants, owner: Player) {
        super.init(constants: constants.constants, owner: owner)
    }
}
