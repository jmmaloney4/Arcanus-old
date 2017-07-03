// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

struct Deck {
    private var contents: [Card]
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

    public mutating func draw() -> Card? {
        if contents.count == 0 {
            return nil
        }
        return contents.remove(at: generateRandomNumber(upTo: contents.count - 1))
    }
    
    public mutating func startingHand(ofSize size: Int) -> Hand? {
        if size > self.count {
            return nil
        }
        
        var hand: [Card] = []
        for _ in 0..<size {
            hand.append(self.draw()!)
        }
        return Hand(hand)
    }
}

struct Hand {
    private var contents: [Card]
    init(_ startingHand: [Card]) {
        contents = startingHand
    }

    func getCard(at index: Int) -> Card? {
        if index >= contents.count {
            return nil
        }
        return contents[index]
    }

    mutating func addCard(_ card: Card) {
        contents.append(card)
    }
}
