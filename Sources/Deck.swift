// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

class Deck: Sequence, CustomStringConvertible {
    private(set) public var contents: [Card]
    public var count: Int {
        get {
            return contents.count
        }
    }

    init?(path: String) {
        guard let fileData = try? String(contentsOfFile: path, encoding: .utf8) else {
            return nil
        }

        let entries = fileData.components(separatedBy: .newlines)

        if entries.count < Rules.cardsInDeck {
            return nil
        }

        contents = []
        for _ in 0 ... Rules.cardsInDeck {
            contents.append(BloodfenRaptor())
        }
    }

    public func draw() -> Card? {
        if contents.count == 0 {
            return nil
        }
        return contents.remove(at: generateRandomNumber(upTo: contents.count - 1))
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
            hand.append(self.draw()!)
        }
        return Hand(hand)
    }

    struct Iterator: IteratorProtocol {
        private enum Iterable {
            case deck(Deck)
            case hand(Hand)
        }

        private var storage: Iterable
        private var index: Int = 0

        init(withDeck deck: Deck) {
            storage = .deck(deck)
        }

        init(withHand hand: Hand) {
            storage = .hand(hand)
        }

        mutating func next() -> Card? {
            var count = 0
            switch storage {
            case .deck(let deck):
                count = deck.count
            case .hand(let hand):
                count = hand.count
            }

            if index >= count {
                return nil
            }

            var rv: Card
            switch storage {
            case .deck(let deck):
                rv = deck.contents[index]
            case .hand(let hand):
                rv = hand.contents[index]
            }

            index += 1
            return rv
        }
    }

    func makeIterator() -> Deck.Iterator {
        return Deck.Iterator(withDeck: self)
    }

    public var description: String { return contents.description }
}

class Hand: Sequence, CustomStringConvertible {
    private(set) public var contents: [Card]
    public var count: Int {
        get {
            return contents.count
        }
    }

    init(_ startingHand: [Card]) {
        contents = startingHand
    }

    func card(at index: Int) -> Card? {
        if index >= contents.count {
            return nil
        }
        return contents[index]
    }

    func addCard(_ card: Card) {
        contents.append(card)
    }

    func makeIterator() -> Deck.Iterator {
        return Deck.Iterator(withHand: self)
    }

    public var description: String { return contents.description }
}

class Board {
    private var playerOneContents: [Minion]
    private var playerTwoContents: [Minion]

    init() {
        playerOneContents = []
        playerTwoContents = []
    }

    /// Parameters:
    ///     - player: 0 for player one. 1 for player two.
    public func add(minion: Minion, atLocation index: Int, toPlayerSide player: Int) {
        switch player {
        case 0:
            playerOneContents.insert(minion, at: index)
        case 1:
            playerTwoContents.insert(minion, at: index)
        default:
            break
        }
    }
}
