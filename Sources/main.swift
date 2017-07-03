// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

print("Hello, World!")

for var k in 0 ... 10 {
    print(generateRandomBool())
}

print(Card.Class.warlock.getSymbol())
print(Card.Class.priest.getSymbol())
print(Card.Class.shaman.getSymbol())

var p1 = CLIPlayer()
var p2 = CLIPlayer()

var game = Game(playerOneInterface: p1, deck: Deck(path: "mage")!, playerTwoInterface: p2, deck: Deck(path: "mage")!)
game.start()

var d = Deck(path: "mage")
