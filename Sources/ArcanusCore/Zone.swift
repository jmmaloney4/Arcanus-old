// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public enum Zones {
    case play
    case deck
    case hand
    case secret
    case graveyard
    case removed
    case setAside
}

internal protocol Zone: Sequence {
    
    var maxSize: Int { get }
    var isEmpty: Bool { get }
    var isFull: Bool { get }
    var count: Int { get }
    var zoneType: Zones { get }
    
    subscript(index: Int) -> Card { get }
    
    func insert(_ card: Card, at position: Int) -> Bool
    func remove(at index: Int) -> Card?
    
}

/*
internal class BasicZone: Zone {

    internal private(set) var contents: [Card] = []
    
    init() {
        
    }
    
}

*/
