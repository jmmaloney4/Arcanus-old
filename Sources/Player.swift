// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

struct Player {
    public private(set) var isPlayerOne: Bool
    public private(set) var goFirst: Bool
    public private(set) var interface: PlayerInterface
    public private(set) var deck: Deck
    public private(set) var hand: Hand

    init(isPlayerOne: Bool,
         isGoingFirst: Bool,
         interface: PlayerInterface,
         deck: Deck,
         startingHand: Hand)
    {
        self.isPlayerOne = isPlayerOne
        goFirst = isGoingFirst
        self.interface = interface
        self.deck = deck
        hand = startingHand
    }

    /// Returns "Player One" if player one or "Player Two" if player two.
    func playerString() -> String {
        return isPlayerOne ? "Player One" : "Player Two"
    }

    mutating func handleEvent(_ event: PlayerEvent) {
        switch event {

        default:
            break
        }
    }
}

protocol PlayerInterface {
    mutating func handleEvent(_ event: PlayerInterfaceEvent)
}

struct CLIPlayer: PlayerInterface {
    mutating func handleEvent(_: PlayerInterfaceEvent) {
    }
}
