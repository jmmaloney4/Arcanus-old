// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public class BloodfenRaptor: Minion {

    static let name = "Bloodfen Raptor"
    static let cost = 2
    static let health = 2
    static let attack = 3

    public var owner: Player
    public var id: Int
    public var name: String { get { return BloodfenRaptor.name } }
    public var cost: Int { get { return BloodfenRaptor.cost } }
    public var cardClass: Class { get { return .neutral } }
    public var set: Set { get { return .basic } }
    public var rarity: Rarity { get { return .free } }
    public var text: String { get { return "" } }
    public var requirements: [PlayRequirement] { get { return [] } }
    public var race: Race { get { return .beast } }
    public var attack: Int = BloodfenRaptor.attack
    public var health: Int = BloodfenRaptor.health
    public var maxHealth: Int = BloodfenRaptor.health
    public var armor: Int = 0

    public init(owner: Player) {
        self.owner = owner
        self.id = owner.game.getNextEntityID()
    }
}

public class TheCoin: Spell {
    static let name = "The Coin"
    static let cost = 0

    public var owner: Player
    public var id: Int
    public var name: String { get { return TheCoin.name } }
    public var cost: Int { get { return 0 } }
    public var cardClass: Class { get { return .neutral } }
    public var set: Set { get { return .basic } }
    public var rarity: Rarity { get { return .free } }
    public var text: String { get { return "Gain 1 Mana Crystal this turn only." } }
    public var requirements: [PlayRequirement] { get { return [] } }

    public init(owner: Player) {
        self.owner = owner
        self.id = owner.game.getNextEntityID()
    }
}

