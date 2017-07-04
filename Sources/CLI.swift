// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

fileprivate func nameForCardClass(_ cardClass: Card.Class) -> String {
    switch cardClass {
    case .neutral: return "Neutral"
    case .druid: return "Druid"
    case .hunter: return "Hunter"
    case .mage: return "Mage"
    case .paladin: return "Paladin"
    case .priest: return "Priest"
    case .rouge: return "Rouge"
    case .shaman: return "Shaman"
    case .warlock: return "Warlock"
    case .warrior: return "Warrior"
    }
}

fileprivate func symbolForCardClass(_ cardClass: Card.Class) -> Character {
    switch cardClass {
    case .neutral: return "¤"
    case .druid: return "🌿"
    case .hunter: return "🏹"
    case .mage: return "🔥"
    case .paladin: return "🔨"
    case .priest: return "✜"
    case .rouge: return "⚔️"
    case .shaman: return "🌋"
    case .warlock: return "🖐️"
    case .warrior: return "🗡"
    }
}

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

    func optionPrompt(_ options: [String], playability passedPlayability: [Card.Playability]? = nil) -> Int {
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

    func playabilityOfHand() -> Card.Playability {
        var rv: Card.Playability = .no
        for card in player.hand {
            switch card.playabilityForPlayer(player) {
            case .yes:
                rv = .yes
            case .withEffect:
                if rv == .no {
                    rv = .withEffect
                }
            default:
                break
            }
        }
        return rv
    }

    func nextAction() -> Player.Action {
        print("Avaliable: \(player.mana), Used: \(player.usedMana), Locked: \(player.lockedMana), Overloaded: \(player.overloadedMana)")

        switch (optionPrompt(["Play Card", "Use Hero Power", "Minion Combat", "Hero Combat", "End Turn"], playability: [playabilityOfHand(), .no, .no, .no, .withEffect])) {
        case 0:
            let index = optionPrompt(player.hand.contents.map({ $0.name }));
            return .playCard(index: index)
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
