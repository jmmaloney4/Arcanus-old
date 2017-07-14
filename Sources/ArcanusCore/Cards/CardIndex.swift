// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

fileprivate let GlobalCardNameIndex: [String: (Player) -> Card] = [
    BloodfenRaptor.name: {BloodfenRaptor(owner: $0)},
    
    TheCoin.name: {TheCoin(owner: $0)},
    Frostbolt.name: {Frostbolt(owner: $0)},
    
    Jaina.name: {Jaina(owner: $0)},
    
    Fireblast.name: {Fireblast(owner: $0)}
]

fileprivate let GlobalCardDbfIDIndex: [Int: (Player) -> Card] = [
    BloodfenRaptor.dbfID: {BloodfenRaptor(owner: $0)},
    
    TheCoin.dbfID: {TheCoin(owner: $0)},
    Frostbolt.dbfID: {Frostbolt(owner: $0)},
    
    Jaina.dbfID: {Jaina(owner: $0)},
    
    Fireblast.dbfID: {Fireblast(owner: $0)}
]

public func getCardForName(_ name: String, withOwner owner: Player) -> Card? {
    if let f = GlobalCardNameIndex[name] {
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

public func getCardForDbfID(_ dbfid: Int, withOwner owner: Player) -> Card? {
    if let f = GlobalCardDbfIDIndex[dbfid] {
        return f(owner)
    } else {
        return nil
    }
}

public func getMinionForDbfID(_ dbfid: Int, withOwner owner: Player) -> Minion? {
    return getCardForDbfID(dbfid, withOwner: owner) as? Minion
}

public func getSpellForDbfID(_ dbfid: Int, withOwner owner: Player) -> Spell? {
    return getCardForDbfID(dbfid, withOwner: owner) as? Spell
}

public func getWeaponForDbfID(_ dbfid: Int, withOwner owner: Player) -> Weapon? {
    return getCardForDbfID(dbfid, withOwner: owner) as? Weapon
}

public func getHeroPowerForDbfID(_ dbfid: Int, withOwner owner: Player) -> HeroPower? {
    return getCardForDbfID(dbfid, withOwner: owner) as? HeroPower
}

public func getHeroForDbfID(_ dbfid: Int, withOwner owner: Player) -> Hero? {
    return getCardForDbfID(dbfid, withOwner: owner) as? Hero
}
