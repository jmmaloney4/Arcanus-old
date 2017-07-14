// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public class BloodfenRaptor: Minion {

    static let name = "Bloodfen Raptor"
    static let dbfID = 216
    static let cost = 2
    static let health = 2
    static let attack = 3

    public private(set) var owner: Player
    public private(set) var id: Int
    public var dbfID: Int { get { return BloodfenRaptor.dbfID } }
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
    public private(set) var isDead: Bool = false
    public private(set) var isFrozen: Bool = false

    public init(owner: Player) {
        self.owner = owner
        self.id = owner.game.getNextEntityID()
    }

    public func takeDamage(_ amount: Int, from soruce: Card) {
        health -= amount
        if health <= 0 {
            isDead = true
        }
    }

    public func frozenBy(_ source: Card) {
        isFrozen = true
    }
}

public class TheCoin: Spell {
    static let name = "The Coin"
    static let dbfID = 1747
    static let cost = 0
    
    public var owner: Player
    public var id: Int
    public var dbfID: Int { get { return TheCoin.dbfID } }
    public var name: String { get { return TheCoin.name } }
    public var cost: Int { get { return TheCoin.cost } }
    public var cardClass: Class { get { return .neutral } }
    public var set: Set { get { return .basic } }
    public var rarity: Rarity { get { return .free } }
    public var text: String { get { return "Gain 1 Mana Crystal this turn only." } }
    public var requirements: [PlayRequirement] { get { return [] } }

    public init(owner: Player) {
        self.owner = owner
        self.id = owner.game.getNextEntityID()
    }

    public func executeSpellText(onTarget target: Character? = nil) throws {
        
    }
}

public class Frostbolt: Spell, Targeter {
    static let name = "Frostbolt"
    static let dbfID = 662
    static let cost = 2
    static let cardClass = Class.mage

    public var owner: Player
    public var id: Int
    public var dbfID: Int { get { return Frostbolt.dbfID } }
    public var name: String { get { return Frostbolt.name } }
    public var cost: Int { get { return Frostbolt.cost } }
    public var cardClass: Class { get { return Frostbolt.cardClass } }
    public var set: Set { get { return .basic } }
    public var rarity: Rarity { get { return .free } }
    public var text: String { get { return "Deal 3 damage to a character and Freeze it." } }
    public var requirements: [PlayRequirement] { get { return [ .requiresTargetToPlay ] } }

    public init(owner: Player) {
        self.owner = owner
        self.id = owner.game.getNextEntityID()
    }

    public func avaliableTargets() -> [Character] {
        return owner.game.charactersInPlay
    }

    public func executeSpellText(onTarget target: Character? = nil) throws {
        if target == nil {
            throw ARError.invalidTarget
        }
        self.dealDamage(amount: 3, to: target!)
        self.freeze(target: target!)
    }
}

public class Jaina: Hero {
    static let name = "Jaina Proudmoore"
    static let dbfID = 637
    static let cost = 0
    static let health = 30

    public var owner: Player
    public var id: Int
    public var dbfID: Int { get { return Jaina.dbfID } }
    public var name: String { get { return Jaina.name } }
    public var cost: Int { get { return Jaina.cost } }
    public var cardClass: Class { get { return .mage } }
    public var set: Set { get { return .basic } }
    public var rarity: Rarity { get { return .free } }
    public var text: String { get { return "" } }
    public var requirements: [PlayRequirement] { get { return [] } }
    public var health: Int = Jaina.health
    public var maxHealth: Int = Jaina.health
    public var armor: Int = 0
    public var weapon: Weapon? = nil
    public private(set) var isDead: Bool = false
    public private(set) var isFrozen: Bool = false
    public private(set) var heroPower: HeroPower

    public init(owner: Player) {
        self.owner = owner
        self.id = owner.game.getNextEntityID()
        self.heroPower = Fireblast(owner: self.owner)
    }
    
    public func takeDamage(_ amount: Int, from source: Card) {
        health -= amount
        if health <= 0 {
            isDead = true
        }
    }
    
    public func frozenBy(_ source: Card) {
        isFrozen = true
    }
    
    public func equipWeapon(_ weapon: Weapon) {
        self.weapon = weapon
    }
}

public class Fireblast: HeroPower, Targeter {
    static let name = "Fireblast"
    static let dbfID: Int = 39791
    static let cost = 2
    
    public var owner: Player
    public var id: Int
    public var dbfID: Int { get { return Fireblast.dbfID } }
    public var name: String { get { return Fireblast.name } }
    public var cost: Int { get { return Fireblast.cost } }
    public var cardClass: Class { get { return .mage } }
    public var set: Set { get { return .basic } }
    public var rarity: Rarity { get { return .free } }
    public var text: String { get { return "Deal 1 damage." } }
    public var requirements: [PlayRequirement] { get { return [.requiresTargetToPlay] } }
    
    public init(owner: Player) {
        self.owner = owner
        self.id = owner.game.getNextEntityID()
    }
    
    public func avaliableTargets() -> [Character] {
        return owner.game.charactersInPlay
    }
    
    public func executeHeroPowerText(onTarget target: Character?) throws {
        self.dealDamage(amount: 1, to: target!)
    }
}

public class Valeera: Hero {
    static let name = "Valeera Sanguinar"
    static let dbfID = 930
    static let cost = 0
    static let health = 30
    
    public var owner: Player
    public var id: Int
    public var dbfID: Int { get { return Valeera.dbfID } }
    public var name: String { get { return Valeera.name } }
    public var cost: Int { get { return Valeera.cost } }
    public var cardClass: Class { get { return .rouge } }
    public var set: Set { get { return .basic } }
    public var rarity: Rarity { get { return .free } }
    public var text: String { get { return "" } }
    public var requirements: [PlayRequirement] { get { return [] } }
    public var health: Int = Valeera.health
    public var maxHealth: Int = Valeera.health
    public var armor: Int = 0
    public var weapon: Weapon? = nil
    public private(set) var isDead: Bool = false
    public private(set) var isFrozen: Bool = false
    public private(set) var heroPower: HeroPower
    
    public init(owner: Player) {
        self.owner = owner
        self.id = owner.game.getNextEntityID()
        self.heroPower = DaggerMastery(owner: self.owner)
    }
    
    public func takeDamage(_ amount: Int, from source: Card) {
        health -= amount
        if health <= 0 {
            isDead = true
        }
    }
    
    public func frozenBy(_ source: Card) {
        isFrozen = true
    }
    
    public func equipWeapon(_ weapon: Weapon) {
        self.weapon = weapon
    }
}

public class DaggerMastery: HeroPower {
    static let name = "Dagger Mastery"
    static let dbfID: Int = 730
    static let cost = 2
    
    public var owner: Player
    public var id: Int
    public var dbfID: Int { get { return DaggerMastery.dbfID } }
    public var name: String { get { return DaggerMastery.name } }
    public var cost: Int { get { return DaggerMastery.cost } }
    public var cardClass: Class { get { return .rouge } }
    public var set: Set { get { return .basic } }
    public var rarity: Rarity { get { return .free } }
    public var text: String { get { return "Equip a 1/2 Dagger." } }
    public var requirements: [PlayRequirement] { get { return [.requiresTargetToPlay] } }
    
    public init(owner: Player) {
        self.owner = owner
        self.id = owner.game.getNextEntityID()
    }
    
    public func executeHeroPowerText(onTarget target: Character?) throws {
        self.owner.hero.equipWeapon(WickedKnife(owner: owner))
    }
}

public class WickedKnife: Weapon {
    static let name = "Wicked Knife"
    static let dbfID: Int = 46054
    static let cost = 1
    static let attack = 1
    static let durability = 2
    
    public var owner: Player
    public var id: Int
    public var dbfID: Int { get { return WickedKnife.dbfID } }
    public var name: String { get { return WickedKnife.name } }
    public var cost: Int { get { return WickedKnife.cost } }
    public var cardClass: Class { get { return .rouge } }
    public var set: Set { get { return .basic } }
    public var rarity: Rarity { get { return .free } }
    public var text: String { get { return "Equip a 1/2 Dagger." } }
    public var requirements: [PlayRequirement] { get { return [.requiresTargetToPlay] } }
    public var attack: Int = WickedKnife.attack
    public var durability: Int = WickedKnife.durability
    
    public init(owner: Player) {
        self.owner = owner
        self.id = owner.game.getNextEntityID()
    }
}
