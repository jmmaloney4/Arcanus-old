// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

internal class Hand: Sequence, CustomStringConvertible {
    private(set) public var contents: [Card]
    public var count: Int {
        get {
            return contents.count
        }
    }
    public var description: String { return contents.description }

    init(_ startingHand: [Card]) {
        contents = startingHand
    }

    subscript(index: Int) -> Card {
        get {
            return card(at: index)
        }
    }

    func card(at index: Int) -> Card {
        return contents[index]
    }

    func removeCard(at index: Int) -> Card? {
        if index >= contents.count || index < 0 {
            return nil
        }
        return contents.remove(at: index)
    }

    func insert(_ card: Card, at index: Int) {
        if index >= contents.count || index < 0 {
            return
        }
        contents.insert(card, at: index)
    }

    func addCard(_ card: Card) {
        contents.append(card)
    }

    struct Iterator: IteratorProtocol {
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

    func makeIterator() -> Iterator {
        return Iterator(self)
    }
}
