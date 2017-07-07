// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

fileprivate func symbolForCardPlayability(_ playability: Playability) -> String {
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

public class CLIPlayer: PlayerInterface {

    public weak var player: Player!

    public init() {
        
    }

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

    func printOptionList(_ options: [String], playability passedPlayability: [Playability]? = nil) {
        var playability: [Playability]
        if passedPlayability == nil {
            playability = Array(repeating: Playability.yes, count: options.count)
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
    }

    func optionPrompt(_ options: [String],
                      playability passedPlayability: [Playability]? = nil) -> Int {
        var playability: [Playability]
        if passedPlayability == nil {
            playability = Array(repeating: Playability.yes, count: options.count)
        } else {
            playability = passedPlayability!
        }

        printOptionList(options, playability: passedPlayability)

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

    public func startingMulligan() {
        print("Starting hand: \(player.hand)")
    }

    public func finishedMulligan() {
        print("New hand: \(player.hand)")
    }

    public func mulliganCard(_ card: Card) -> Bool {
        return boolPrompt("Mulligan \(card)")!;
    }

    public func nextAction() -> Player.Action {
        print("Avaliable: \(player.mana), Used: \(player.usedMana), Locked: \(player.lockedMana), Overloaded: \(player.overloadedMana)")
        print("In Play: \(player.game.charactersInPlay)")

        let handPlayability = player.playabilityOfHand()
        switch (optionPrompt(["Play Card", "Use Hero Power", "Minion Combat", "Hero Combat", "End Turn"],
                             playability: [handPlayability == .no ? .withEffect : .yes, .no, .no, .no, .withEffect])) {
        case 0:
            let handOptions = player.hand.contents.map({ $0.description })
            let handPlayabilityList = player.hand.contents.map({ $0.playability })

            // If no cards can be played, just print out hand
            if handPlayability == .no {
                printOptionList(handOptions, playability: handPlayabilityList)
                return nextAction()
            }

            let index = optionPrompt(handOptions, playability: handPlayabilityList);
            let card = player.hand[index]

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
                /*if card.hasRequirement(.requiresTargetToPlay) {
                    print("Needs target")

                    // var targets = player.game.charactersInPlay.filter({})
                }
                 */
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
}
