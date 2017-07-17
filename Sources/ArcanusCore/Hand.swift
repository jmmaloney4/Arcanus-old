// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

internal class Hand: Zone, Sequence, CustomStringConvertible {
    internal private(set) var contents: [Card]
    internal var count: Int { get { return contents.count } }
    internal var maxSize: Int { get { return player.game.rules.maxCardsInHand } }
    internal var isEmpty: Bool { get { return contents.isEmpty } }
    internal var isFull: Bool { get { return count >= maxSize } }
    internal var zoneType: Zones { get { return .hand } }
    internal var description: String { return contents.description }

    var player: Player!
    
    internal init(_ startingHand: [Card], player: Player) {
        contents = startingHand
        self.player = player
    }
    
    internal subscript(index: Int) -> Card {
        get {
            return card(at: index)
        }
    }

    internal func card(at index: Int) -> Card {
        return contents[index]
    }

    internal func remove(at index: Int) -> Card? {
        if index >= contents.count || index < 0 {
            return nil
        }
        return contents.remove(at: index)
    }

    internal func insert(_ card: Card, at index: Int) -> Bool {
        if index >= contents.count || index < 0 {
            return false
        }
        contents.insert(card, at: index)
        return true
    }

    internal func addCard(_ card: Card) {
        contents.append(card)
    }

    /// Returns .yes if any of the cards in this hand are .yes or .withEffect, 
    /// otherwise returns .no
    internal func overallPlayability() -> Playability {
        return contents.reduce(Playability.no, { result, next in
            switch next.playability {
            case .yes:
                return .yes
            case .withEffect:
                return .yes
            case .no:
                return result
            }
        })
    }

    internal struct Iterator: IteratorProtocol {
        private var storage: Hand
        private var index: Int = 0

        init(_ hand: Hand) {
            self.storage = hand
        }

        mutating func next() -> Card? {
            if index >= storage.count {
                return nil
            }

            index += 1
            return storage.contents[index - 1]
        }
    }

    internal func makeIterator() -> Iterator {
        return Iterator(self)
    }
}
