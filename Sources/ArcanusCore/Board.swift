// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

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

    subscript(index: Int) -> Minion {
        get {
            return minion(at: index)
        }
    }

    /// Parameters:
    ///     - player: 0 for player one. 1 for player two.
    public func insert(_ minion: Minion, at index: Int) {
        contents.insert(minion, at: index)
    }

    public func minion(at: Int) -> Minion {
        return contents[at]
    }

    struct Iterator: IteratorProtocol {
        private var storage: Board
        private var index: Int = 0

        init(_ board: Board) {
            storage = board
        }

        mutating func next() -> Minion? {
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
