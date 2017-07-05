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
        if contents.count == 0 {
            return nil
        }
        let rv = contents.remove(at: generateRandomNumber(upTo: contents.count - 1))
        if triggerEvent {
            Event.cardDrawn(rv, by: player).raise()
        }
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
        private enum Iterable {
            case deck(Deck)
            case hand(Hand)
            case board(Board)
        }

        private var storage: Iterable
        private var index: Int = 0

        init(withDeck deck: Deck) {
            storage = .deck(deck)
        }

        init(withHand hand: Hand) {
            storage = .hand(hand)
        }

        init(withBoard board: Board) {
            storage = .board(board)
        }

        mutating func next() -> Card? {
            var count = 0
            switch storage {
            case .deck(let deck):
                count = deck.count
            case .hand(let hand):
                count = hand.count
            case .board(let board):
                count = board.count
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
            case .board(let board):
                rv = board.contents[index]
            }

            index += 1
            return rv
        }
    }

    func makeIterator() -> Deck.Iterator {
        return Deck.Iterator(withDeck: self)
    }
}

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

    func card(at index: Int) -> Card? {
        if index >= contents.count || index < 0 {
            return nil
        }
        return contents[index]
    }

    func removeCard(at index: Int) -> Card? {
        if index >= contents.count || index < 0 {
            return nil
        }
        return contents.remove(at: index)
    }

    func insertCard(_ card: Card, at index: Int) {
        if index >= contents.count || index < 0 {
            return
        }
        contents.insert(card, at: index)
    }

    func addCard(_ card: Card) {
        contents.append(card)
    }

    func makeIterator() -> Deck.Iterator {
        return Deck.Iterator(withHand: self)
    }
}

internal class Board: Sequence, CustomStringConvertible {
    private(set) public var contents: [Minion]
    public var count: Int {
        get {
            return contents.count
        }
    }
    public var description: String { return contents.description }

    init() {
        contents = []
    }

    /// Parameters:
    ///     - player: 0 for player one. 1 for player two.
    public func add(minion: Minion, at index: Int) {
        contents.insert(minion, at: index)
    }

    public func minion(at: Int) -> Minion {
        return contents[at]
    }

    func makeIterator() -> Deck.Iterator {
        return Deck.Iterator(withBoard: self)
    }
}
