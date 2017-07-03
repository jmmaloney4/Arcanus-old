// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

class Player {
    public private(set) var isPlayerOne: Bool
    public private(set) var goFirst: Bool
    public private(set) var interface: PlayerInterface
    public private(set) var deck: Deck
    public private(set) var hand: Hand

    init(isPlayerOne: Bool,
         isGoingFirst: Bool,
         interface: inout PlayerInterface,
         deck: inout Deck)
    {
        self.isPlayerOne = isPlayerOne
        goFirst = isGoingFirst
        self.interface = interface
        self.deck = deck
        hand = deck.startingHand(ofSize: goFirst ? Rules.startingHandSizeGoFirst : Rules.startingHandSizeGoSecond)!

        interface.player = self

        interface.mulliganCard(at: 0)
    }

    /// Returns "Player One" if player one or "Player Two" if player two.
    func playerString() -> String {
        return isPlayerOne ? "Player One" : "Player Two"
    }

    func handleEvent(_ event: PlayerEvent) {
        switch event {

        default:
            break
        }
    }
}

protocol PlayerInterface {
    weak var player: Player! { get set }

    mutating func handleEvent(_ event: PlayerInterfaceEvent)

    func mulliganCard(at index: Int) -> Bool;
}

struct CLIPlayer: PlayerInterface {

    weak var player: Player!

    func boolPrompt(_ prompt:String) -> Bool? {
        while true {
            print(prompt, terminator: "? [y/n]: ")

            guard let line = readLine() else {
                return nil
            }

            if line.hasPrefix("Y") || line.hasPrefix("y") {
                return true
            } else if line.hasPrefix("N") || line.hasPrefix("n") {
                return false
            }
        }
    }

    func mulliganCard(at index: Int) -> Bool {
        return boolPrompt("Mulligan \(player.hand.card(at: index)!)")!;
    }

    mutating func handleEvent(_ event: PlayerInterfaceEvent) {
        switch event {
        case .gameStarted:
            print("Game starting for \(player.playerString()), going \(player.goFirst ? "first" : "second")");
        }
    }
}
