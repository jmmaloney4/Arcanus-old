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

        interface.optionPrompt(["Hello 1", "Hello 2"], playability: [.no, .withEffect])
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

    func optionPrompt(_ options: [String], playability: [Card.Playability]?) -> Int?
}

struct CLIPlayer: PlayerInterface {

    enum TextColor {
        case red
        case green
        case yellow

        /*
        public static let ANSI_BLACK = "\u{001B}[30m";
        public static let ANSI_RED = "\u{001B}[31m";
        public static let ANSI_GREEN = "\u{001B}[32m";
        public static let ANSI_YELLOW = "\u{001B}[33m";
        public static let ANSI_BLUE = "\u{001B}[34m";
        public static let ANSI_PURPLE = "\u{001B}[35m";
        public static let ANSI_CYAN = "\u{001B}[36m";
        public static let ANSI_WHITE = "\u{001B}[37m";
        public static let ANSI_CLEAR = "\u{033}[2J\033[;H"
        */

        func colorString(_ string: String) -> String {
            var rv = ""
            switch self {
            case .red:
                rv += "\u{001B}[31m"
            case .green:
                rv += "\u{001B}[32m"
            case .yellow:
                rv += "\u{001B}[33m"
            }
            rv += string
            rv += "\u{001B}[0m" // ANSI_RESET
            return rv
        }
    }

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

    func optionPrompt(_ options: [String], playability: [Card.Playability]? = nil) -> Int? {
        for k in 0..<options.count {
            if playability != nil {
                switch playability![k] {
                case .yes:
                    print(TextColor.green.colorString(playability![k].getSymbol()), terminator: " ")
                case .no:
                    print(TextColor.red.colorString(playability![k].getSymbol()), terminator: " ")
                case .withEffect:
                    print(TextColor.yellow.colorString(playability![k].getSymbol()), terminator: " ")
                }
            }
            print(options[k])
        }

        while true {
            print("[0-\(options.count - 1)]", terminator: ": ")
            guard let line = readLine() else {
                return nil
            }

            let rv = Int(line)
            if rv == nil || rv! < 0 || rv! > options.count - 1 {
                continue
            } else {
                return rv
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
