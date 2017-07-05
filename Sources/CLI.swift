// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

fileprivate func symbolForCardPlayability(_ playability: Card.Playability) -> String {
    switch playability {
    case .no:
        return "✘"
    case .yes:
        return "✔"
    case .withEffect:
        return "▶︎"
    }
}

fileprivate enum TextColor {
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

class CLIPlayer: PlayerInterface {

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

    func optionPrompt(_ options: [String],
                      playability passedPlayability: [Card.Playability]? = nil) -> Int {
        var playability: [Card.Playability]
        if passedPlayability == nil {
            playability = Array(repeating: Card.Playability.yes, count: options.count)
        } else {
            playability = passedPlayability!
        }

        for k in 0..<options.count {
            print(k, terminator: " ")
            switch playability[k] {
            case .yes:
                print(TextColor.green.colorString(symbolForCardPlayability(playability[k])), terminator: " ")
            case .no:
                print(TextColor.red.colorString(symbolForCardPlayability(playability[k])), terminator: " ")
            case .withEffect:
                print(TextColor.yellow.colorString(symbolForCardPlayability(playability[k])), terminator: " ")
            }
            print(options[k])
        }

        while true {
            print("[0-\(options.count - 1)]", terminator: ": ")
            guard let line = readLine() else {
                continue
            }

            let rv = Int(line)
            if rv == nil || rv! < 0 || rv! > options.count - 1 || playability[rv!] == .no {
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

        switch (optionPrompt(["Play Card", "Use Hero Power", "Minion Combat", "Hero Combat", "End Turn"],
                             playability: [player.playabilityOfHand(), .no, .no, .no, .withEffect])) {
        case 0:
            let index = optionPrompt(player.hand.contents.map({ $0.description }),
                                     playability: player.hand.contents.map({$0.playabilityForPlayer(player)}));
            let card = player.hand.card(at: index)!

            if card is Minion {
                if player.board.contents.isEmpty {
                    return .playCard(index: index, location: 0, target: nil)
                }

                var boardOptions: [String] = ["Left Side of \(player.board.minion(at: 0))"]
                for k in 1..<player.board.count {
                    boardOptions.append("Between \(player.board.minion(at: k - 1)) and \(player.board.minion(at: k))")
                }
                boardOptions.append("Right Side of \(player.board.minion(at: player.board.count - 1))")
                let location = optionPrompt(boardOptions)

                

                return .playCard(index: index, location: location, target: nil)
            } else if card is Spell {
                return .playCard(index: index, location: nil, target: nil)
            }
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

    func eventRaised(_ event: Event) {
        
    }

    func finishedProcessingEvent(_ event: Event) {

    }
}
