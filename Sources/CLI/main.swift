// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Arcanus

func main() {

    if CommandLine.arguments.count < 3 {
        print("Usage: \(CommandLine.arguments[0]) [deck player1] [deck player2]")
        exit(1)
    }

    var p1: Arcanus.PlayerInterface = CLIPlayer()
    var p2: PlayerInterface = CLIPlayer()

    let game = Game(playerOneInterface: &p1,
                        deckPath: CommandLine.arguments[1],
                        playerTwoInterface: &p2,
                        deckPath: CommandLine.arguments[1])
    game.start()
 
}

main()
