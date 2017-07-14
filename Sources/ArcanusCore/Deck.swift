// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import VarInt

private func readCardsOutOfDbfArray(_ ints:[Int64], index: Int, owner: Player) throws -> [Card] {
    var rv: [Card] = []
    
    return rv
}

// See https://www.reddit.com/r/hearthstone/comments/6f2xyk/how_to_encodedecode_deck_codes/
// for info on how the encoding works
internal class Deck: Sequence, CustomStringConvertible {
    private(set) public var contents: [Card]
    public var count: Int { get { return contents.count } }
    public var description: String { return contents.map({$0.description}).joined(separator: "\n") }
    public weak var player: Player!
    
    init(cards: [Card], player: Player) throws {
        if cards.count != player.game.rules.cardsInDeck {
            throw ARError.invalidInput
        }
        self.contents = cards
        self.player = player
    }
    
    convenience init(path: String, player: Player) throws {
        guard let fileData = try? String(contentsOfFile: path, encoding: .utf8) else {
            throw ARError.readingFileFailed(path: path)
        }
        
        let entries = fileData.components(separatedBy: .newlines)
        
        if entries.count < player.game.rules.cardsInDeck {
            throw ARError.invalidFormat
        }
        
        var cards: [Card] = []
        
        let usableEntries = entries.prefix(player.game.rules.cardsInDeck)
        for entry in usableEntries {
            if let card = getCardForName(entry, withOwner: player) {
                cards.append(card)
            } else {
                throw ARError.cardForNameDoesNotExist(entry)
            }
        }
        do {
            try self.init(cards: cards, player: player)
        } catch {
            throw error
        }
    }
    
    convenience init(deckstring: String, player: Player) throws {
        guard var data = Data(base64Encoded: deckstring) else {
            throw ARError.invalidInput
        }
        
        var bytes: [UInt8] = Array(repeating: 0, count: data.count)
        data.copyBytes(to: UnsafeMutablePointer(&bytes), count: data.count)
        var ints: [Int64] = []
        while true {
            let (int, count) = varInt(bytes)
            if count <= 0 {
                break
            }
            ints.append(int)
            bytes.removeFirst(count)
        }
        
        // Check that there is only one item in the heroes array
        if ints[3] != 1 {
            throw ARError.invalidFormat
        }
        
        // The hero would be ints[4] but we don't actually care what class this 
        // is, that is probably up to the Player class to check, but really is 
        // unimplemented for now
        
        let x1index = 5
        let x1count = Int(ints[x1index])
        let x2index = x1index + 1 + x1count
        let x2count = Int(ints[x2index])
        let xnindex = x2index + 1 + x2count
        let xncount = Int(ints[xnindex])
        
        var cards: [Card] = []
        
        for k in (x1index + 1)..<(x1index + 1 + x1count) {
            guard let card = getCardForDbfID(Int(ints[k]), withOwner: player) else {
                throw ARError.cardForDbfIDDoesNotExist(Int(ints[k]))
            }
            cards.append(card)
        }
        
        for k in (x2index + 1)..<(x2index + 1 + x2count) {
            for _ in 0..<2 {
                guard let card = getCardForDbfID(Int(ints[k]), withOwner: player) else {
                    throw ARError.cardForDbfIDDoesNotExist(Int(ints[k]))
                }
                cards.append(card)
            }
        }
        
        for k in stride(from: (xnindex + 1), to: (xnindex + 1 + (xncount * 2)), by: 2) {
            for _ in 0..<ints[k + 1] {
                guard let card = getCardForDbfID(Int(ints[k]), withOwner: player) else {
                    throw ARError.cardForDbfIDDoesNotExist(Int(ints[k]))
                }
                cards.append(card)
            }
        }
        
        do {
            try self.init(cards: cards, player: player)
        } catch {
            throw error
        }
    }
    
    public func getDeckstring() -> String {
        let heroes: [Hero] = [player.hero]
        var cards: [Int:Int] = [:]
        for card in self {
            if let count = cards[card.dbfID] {
                cards[card.dbfID] = count + 1
            } else {
                cards[card.dbfID] = 1
            }
        }
        
        var x1cards: [Int] = []
        var x2cards: [Int] = []
        var xncards: [Int:Int] = [:]
        
        for (dbfID, count) in cards {
            switch count {
            case 1:
                x1cards.append(dbfID)
            case 2:
                x2cards.append(dbfID)
            default:
                xncards[dbfID] = count
            }
        }
        
        var bytes: [UInt8] = []
        bytes.append(contentsOf: putVarInt(0)) // Reserved Byte
        bytes.append(contentsOf: putVarInt(1)) // Version 1
        bytes.append(contentsOf: putVarInt(2)) // Format. 1 = wild, 2 = standard
        
        bytes.append(contentsOf: putVarInt(Int64(heroes.count)))
        for hero in heroes {
            bytes.append(contentsOf: putVarInt(Int64(hero.dbfID)))
        }
        
        bytes.append(contentsOf: putVarInt(Int64(x1cards.count)))
        for card in x1cards {
            bytes.append(contentsOf: putVarInt(Int64(card)))
        }
        
        bytes.append(contentsOf: putVarInt(Int64(x2cards.count)))
        for card in x2cards {
            bytes.append(contentsOf: putVarInt(Int64(card)))
        }
        
        bytes.append(contentsOf: putVarInt(Int64(xncards.count)))
        for (card, count) in xncards {
            bytes.append(contentsOf: putVarInt(Int64(card)))
            bytes.append(contentsOf: putVarInt(Int64(count)))
        }
        
        return Data(bytes: bytes).base64EncodedString()
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
