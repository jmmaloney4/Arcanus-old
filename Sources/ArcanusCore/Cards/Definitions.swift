// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

// MARK: - Minion
public class BloodfenRaptor: Minion {
    internal static let constants: MinionConstants = MinionConstants(name: "Bloodfen Raptor",
                                                                     cost: 2,
                                                                     cardClass: .neutral,
                                                                     set: .basic,
                                                                     rarity: .free,
                                                                     requirements: [],
                                                                     text: "",
                                                                     race: .neutral,
                                                                     attack: 3,
                                                                     health: 2)

    public init(owner: Player) {
        super.init(constants: BloodfenRaptor.constants, owner: owner)
    }
}

public class KnifeJuggler: Minion {
    internal static let constants: MinionConstants = MinionConstants(name: "Knife Juggler",
                                                                     cost: 2,
                                                                     cardClass: .neutral,
                                                                     set: .classic,
                                                                     rarity: .rare,
                                                                     requirements: [],
                                                                     text: "After you summon a minion, deal 1 damage to a random enemy.",
                                                                     race: .neutral,
                                                                     attack: 2,
                                                                     health: 2)

    public init(owner: Player) {
        super.init(constants: KnifeJuggler.constants, owner: owner)
    }
}

public class StampedingKodo: Minion {
    internal static let constants: MinionConstants = MinionConstants(name: "Stampeding Kodo",
                                                                     cost: 5,
                                                                     cardClass: .neutral,
                                                                     set: .classic,
                                                                     rarity: .rare,
                                                                     requirements: [],
                                                                     text: "Battlecry: Destroy a random enemy minion with 2 or less Attack.",
                                                                     race: .beast,
                                                                     attack: 3,
                                                                     health: 5)

    public init(owner: Player) {
        super.init(constants: StampedingKodo.constants, owner: owner)
    }
}

public class VioletTeacher: Minion {
    internal static let constants: MinionConstants = MinionConstants(name: "Violet Teacher",
                                                                     cost: 4,
                                                                     cardClass: .neutral,
                                                                     set: .classic,
                                                                     rarity: .rare,
                                                                     requirements: [],
                                                                     text: "Whenever you cast a spell, summon a 1/1 Violet Apprentice.",
                                                                     race: .neutral,
                                                                     attack: 3,
                                                                     health: 5)

    public init(owner: Player) {
        super.init(constants: VioletTeacher.constants, owner: owner)
    }
}

public class VioletApprentice: Minion {
    internal static let constants: MinionConstants = MinionConstants(name: "Violet Apprentice",
                                                                     cost: 1,
                                                                     cardClass: .neutral,
                                                                     set: .classic, rarity: .uncollectible,
                                                                     requirements: [],
                                                                     text: "",
                                                                     race: .neutral,
                                                                     attack: 1,
                                                                     health: 1)

    public init(owner: Player) {
        super.init(constants: VioletApprentice.constants, owner: owner)
    }
}

// MARK: - Spell
public class TheCoin: Spell {
    internal static let constants = SpellConstants(name: "The Coin",
                                                   cost: 0,
                                                   cardClass: .neutral,
                                                   set: .basic,
                                                   rarity: .uncollectible,
                                                   requirements: [],
                                                   text: "Gain 1 Mana Crystal this turn only.")

    public init(owner: Player) {
        super.init(constants: TheCoin.constants, owner: owner)
    }
}

public class Frostbolt: Spell {
    internal static let constants = SpellConstants(name: "Frostbolt",
                                                   cost: 3,
                                                   cardClass: .mage,
                                                   set: .basic,
                                                   rarity: .free,
                                                   requirements: [.requiresTargetToPlay],
                                                   text: "Deal 3 damage to a character and Freeze it.")

    public init(owner: Player) {
        super.init(constants: Frostbolt.constants, owner: owner)
    }
}

public class Cleave: Spell {
    internal static let constants = SpellConstants(name: "Cleave",
                                                   cost: 2,
                                                   cardClass: .warrior,
                                                   set: .basic,
                                                   rarity: .free,
                                                   requirements: [.requiresMinEnemyMinions(2)],
                                                   text: "Deal 2 damage to two random enemy minions.")

    public init(owner: Player) {
        super.init(constants: Cleave.constants, owner: owner)
    }
}

public class Shatter: Spell {
    internal static let constants = SpellConstants(name: "Shatter",
                                                   cost: 2,
                                                   cardClass: .mage,
                                                   set: .oldGods, rarity: .common,
                                                   requirements: [.requiresFrozenTarget, .requiresMinionTarget, .requiresTargetToPlay],
                                                   text: "Destroy a Frozen minion.")

    public init(owner: Player) {
        super.init(constants: Shatter.constants, owner: owner)
    }
}

// MARK: - Weapon

// MARK: - HeroPower
public class Fireblast: HeroPower {
    internal static let constants = HeroPowerConstants(name: "Fireblast",
                                                       cost: 2,
                                                       cardClass: .mage,
                                                       set: .basic,
                                                       rarity: .uncollectible,
                                                       requirements: [.requiresTargetToPlay],
                                                       text: "Deal 1 damage.")

    public init(owner: Player) {
        super.init(constants: Fireblast.constants, owner: owner)
    }
}

// MARK: - Hero

public class Jaina: Hero {
    internal static let constants = HeroConstants(name: "Jaina Proudmoore",
                                                  cost: 0,
                                                  cardClass: .mage,
                                                  set: .basic,
                                                  rarity: .uncollectible,
                                                  requirements: [],
                                                  text: "", attack: 0, health: 30)

    public init(owner: Player) {
        super.init(constants: Jaina.constants, owner: owner)
    }
}
