// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

struct Deck {
    private var contents: [Card]

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
}

struct Hand {
    private var contents: [Card]
    init(startingHand: [Card]) {
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
