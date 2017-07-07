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
    default:
        return nil
    }
}

public protocol Hero: Character {

}
