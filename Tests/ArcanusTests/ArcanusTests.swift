// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import ArcanusCore

public class BasicTests: XCTestCase {
    public static var allTests = {
        return [
            ("testDeckToDeckString", testDeckToDeckString),
            ("testDeckFromDeckString", testDeckFromDeckString)
            ]
    }()
    
    var game: Game!
    var player: Player!
    
    public override func setUp() {
        super.setUp()
        
        var p1: PlayerInterface = CLIPlayer()
        var p2: PlayerInterface = CLIPlayer()
        
        game = Game(playerOneInterface: &p1,
                    deckPath: "", //CommandLine.arguments[1],
                    playerTwoInterface: &p2,
                    deckPath: "") //CommandLine.arguments[2])
        player = game.players[0]
    }
    
    public override func tearDown() {
        super.tearDown()
    }
    
    func testDeckToDeckString() {
        let deck1 = try? Deck(cards: Array(repeatElement(BloodfenRaptor(owner: player), count: game.rules.cardsInDeck)), player: player)
        XCTAssertNotNil(deck1)
        XCTAssertEqual(deck1?.getDeckstring(), "AAIEAvoJAAACsAM8")
    }
    
    func testDeckFromDeckString() {
        let deck2 = try? Deck(deckstring: "AAIEAvoJAAACsAM8", player: player)
        XCTAssertNotNil(deck2)
        if deck2 == nil {
            return
        }
        for k in 0..<game.rules.cardsInDeck {
            XCTAssertEqual(deck2?.contents[k].dbfID, BloodfenRaptor.dbfID)
        }
    }
}
