// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

class Player {
    public private(set) var isPlayerOne: Bool
    public private(set) var goingFirst: Bool
    public private(set) var interface: PlayerInterface
    public private(set) var deck: Deck
    public private(set) var hand: Hand

    public var mana: Int {
        get {
            var rv = manaCrystals
            rv += bonusMana
            rv -= usedMana
            rv -= lockedMana
            return rv
        }
    };
    public private(set) var usedMana: Int = 0;
    public private(set) var manaCrystals: Int = 0;
    public private(set) var bonusMana: Int = 0;
    public private(set) var lockedMana: Int = 0;
    public private(set) var overloadedMana: Int = 0;

    public weak var game: Game!;

    init(isPlayerOne: Bool,
         isGoingFirst: Bool,
         interface: inout PlayerInterface,
         deck: inout Deck,
         game: Game)
    {
        self.isPlayerOne = isPlayerOne
        goingFirst = isGoingFirst
        self.interface = interface
        self.deck = deck
        hand = deck.startingHand(ofSize: goingFirst ? Rules.startingHandSizeGoFirst : Rules.startingHandSizeGoSecond)!

        self.game = game
        self.interface.player = self
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

    func runMulligan() {
        interface.startingMulligan()

        let newHand = Hand([])
        for c in hand {
            if interface.mulliganCard(c) {
                newHand.addCard(deck.draw()!)
                deck.shuffleIn(c)
            } else {
                newHand.addCard(c)
            }
        }

        if !goingFirst {
            newHand.addCard(TheCoin())
        }

        hand = newHand
        interface.finishedMulligan()
    }

    enum Action {
        case playCard(Card)
        case heroPower
        case minionCombat
        case heroCombat
        case endTurn
    }

    func takeTurn(_ turn: Int) {
        if manaCrystals < Rules.maxManaCrystals {
            manaCrystals += 1
        }
        usedMana = 0
        bonusMana = 0
        lockedMana = overloadedMana
        overloadedMana = 0

        while true {
            let action = interface.nextAction()
            switch action {
            case .playCard(let card):
                print("Playing a \(card)")
            case .endTurn:
                return
            default:
                break
            }
        }
    }
}

protocol PlayerInterface {
    weak var player: Player! { get set }

    mutating func handleEvent(_ event: PlayerInterfaceEvent)

    func startingMulligan()
    func mulliganCard(_ card: Card) -> Bool
    func finishedMulligan()

    func optionPrompt(_ options: [String], playability: [Card.Playability]?) -> Int
    func nextAction() -> Player.Action
}

class CLIPlayer: PlayerInterface {

    enum TextColor {
        case red
        case green
        case yellow

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

            switch line {
            case "y", "Y", "yes", "Yes","YES":
                return true
            case "n", "N", "no", "No","NO":
                return false
            default:
                continue;
            }
        }
    }

    func optionPrompt(_ options: [String], playability: [Card.Playability]? = nil) -> Int {
        for k in 0..<options.count {
            print(k, terminator: " ")
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
                continue
            }

            let rv = Int(line)
            if rv == nil || rv! < 0 || rv! > options.count - 1 {
                continue
            } else {
                return rv!
            }
        }
    }

    func startingMulligan() {
        print("Starting hand: \(player.hand)")
    }

    func finishedMulligan() {
        print("New hand: \(player.hand)")
    }

    func mulliganCard(_ card: Card) -> Bool {
        return boolPrompt("Mulligan \(card)")!;
    }

    func nextAction() -> Player.Action {
        print("Avaliable: \(player.mana), Used: \(player.usedMana), Locked: \(player.lockedMana), Overloaded: \(player.overloadedMana)")

        switch (optionPrompt(["Play Card", "Use Hero Power", "Minion Combat", "Hero Combat", "End Turn"], playability: [.yes, .no, .no, .no, .withEffect])) {
        case 0:
            let index = optionPrompt(player.hand.contents.map({ $0.name }));
            return .playCard(player.hand.card(at: index)!)
        case 1:
            return .heroPower
        case 2:
            return .minionCombat
        case 3:
            return .heroCombat
        case 4:
            return .endTurn
        default:
            // Error
            assert(false, "Shouldn't reach this switch case")
        }
        return .endTurn
    }


    func handleEvent(_ event: PlayerInterfaceEvent) {
        switch event {
        case .gameStarted:
            print("Game starting for \(player.playerString()), going \(player.goingFirst ? "first" : "second")");
        }
    }
}
