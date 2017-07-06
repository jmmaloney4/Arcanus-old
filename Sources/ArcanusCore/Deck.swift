// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

internal class Deck: Sequence, CustomStringConvertible {
    private(set) public var contents: [Card] = []
    public var count: Int {
        get {
            return contents.count
        }
    }
    public var description: String { return contents.map({$0.description}).joined(separator: "\n") }
    public weak var player: Player!

    init?(path: String, player: Player) {
        self.player = player

        guard let fileData = try? String(contentsOfFile: path, encoding: .utf8) else {
            return nil
        }

        let entries = fileData.components(separatedBy: .newlines)

        if entries.count < Game.defaultRules.cardsInDeck {
            return nil
        }

        let usableEntries = entries.prefix(Game.defaultRules.cardsInDeck)
        for entry in usableEntries {
            contents.append(Card.cardForName(entry, withOwner: self.player)!)
        }
    }

    public func draw(triggerEvent: Bool = true) -> Card? {
        if contents.isEmpty {
            return nil
        }
        let rv = contents.remove(at: player.game.rng.next(upTo: contents.count - 1))
        return rv
    }

    public func shuffleIn(_ card: Card) {
        contents.append(card)
    }

    public func startingHand(ofSize size: Int) -> Hand? {
        if size > self.count {
            return nil
        }

        var hand: [Card] = []
        for _ in 0..<size {
            hand.append(self.draw(triggerEvent: false)!)
        }
        return Hand(hand)
    }

    struct Iterator: IteratorProtocol {
        private var storage: Deck
        private var index: Int = 0

        init(_ deck: Deck) {
            storage = deck
        }

        mutating func next() -> Card? {
            if index >= storage.count {
                return nil
            }
            index += 1
            return storage.contents[index - 1]
        }
    }

    func makeIterator() -> Deck.Iterator {
        return Iterator(self)
    }
}
