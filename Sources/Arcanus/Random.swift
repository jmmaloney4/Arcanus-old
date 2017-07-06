// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Squall

public class Random {
    private var rng: MersenneTwisterGenerator
    public private(set) var seed: UInt32

    init(seed: UInt32 = UInt32(Date().timeIntervalSinceReferenceDate)) {
        self.seed = seed
        rng = MersenneTwisterGenerator(seed: seed)
    }

    /// Portable function to generate a random number in a certian range.
    ///
    /// - Parameters:
    ///     - min: The minimum value in the range. By default is set to 0.
    ///     - max: The maximum value in the range. By default is set to Int.max.
    public func next(from min: Int = 0, upTo max: Int = Int.max) -> Int {
        let range = UInt32((min...max).count)
        return Int(rng.next()! % range) + min
    }

    /// Portable function to generate a random Bool.
    public func nextBool() -> Bool {
        return next(from: 0, upTo: 1) == 0 ? true : false
    }
}
