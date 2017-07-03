// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

if CommandLine.arguments.count < 3 {
    print("Usage: \(CommandLine.arguments[0]) [deck player1] [deck player2]")
}

var p1: PlayerInterface = CLIPlayer()
var p2: PlayerInterface = CLIPlayer()

var deck1 = Deck(path: CommandLine.arguments[1])!
var deck2 = Deck(path: CommandLine.arguments[2])!

var game = Game(playerOneInterface: &p1,
                deck: &deck1,
                playerTwoInterface: &p2,
                deck: &deck2)
game.start()
