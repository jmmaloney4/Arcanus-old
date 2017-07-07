// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public protocol Character: Card {
    var attack: Int { get }
    var health: Int { get }
    var maxHealth: Int { get }
    var armor: Int { get }

    func damage(_ amount: Int)

    var isDead: Bool { get }
}
