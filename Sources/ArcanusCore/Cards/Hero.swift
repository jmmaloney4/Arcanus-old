// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

func getDefaultHeroForClass(_ cardClass: Class, owner: Player) -> Hero? {
    switch cardClass {
    case .mage:
        return Jaina(owner: owner)
    case .rouge:
        return Valeera(owner: owner)
    default:
        return nil
    }
}

public protocol Hero: Character {
    var heroPower: HeroPower { get }
    var weapon: Weapon? { get }
    
    func equipWeapon(_ weapon: Weapon)
}

extension Hero {
    public var description: String {
        get {
            return "\(name) (ID: \(id), owner: \(owner.goingFirst ? 1 : 2), \(cost) Mana, \(health) Health, \(armor) Armor) [\(text)]"
        }
    }
    
    public var attack: Int {
        get {
            if weapon != nil {
                return weapon!.attack
            } else {
                return 0
            }
        }
    }
}
