// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public enum Race: CustomStringConvertible {
    case neutral
    case beast

    public var description: String {
        get {
            switch self {
            case .neutral: return "Neutral"
            case .beast: return "Beast"
            }
        }
    }
}

public protocol Minion: Character {
    var race: Race { get }

    func attack(_ target: Minion)
    func attackedBy(_ source: Minion)
}

extension Minion {
    public var description: String {
        get {
            var rv = "\(name) (ID: \(id), owner: \(owner.goingFirst ? 1 : 2)) (\(rarity.symbol), "
            if race != .neutral {
                rv.append("\(race), ")
            }
            rv.append("\(cost) Mana, \(attack)/\(health)) [\(text)]")
            return rv
        }
    }

    public func attack(_ target: Minion) {
        dealDamage(amount: self.attack, to: target)
        target.attackedBy(self)
    }

    public func attackedBy(_ source: Minion) {
        dealDamage(amount: self.attack, to: source)
    }
}
