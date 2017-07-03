// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

/// Portable function to generate a random number in a certian range.
///
/// - Parameters:
///     - min: The minimum value in the range. By default is set to 0.
///     - max: The maximum value in the range. By default is set to Int.max.
func generateRandomNumber(from min: Int = 0, upTo max: Int = Int.max) -> Int {
    var range = max - min
    #if os(Linux)
        return Int(random() % (range + 1)) + min
    #else
        return Int(arc4random_uniform(UInt32(range + 1))) + min
    #endif
}

/// Portable function to generate a random Bool.
func generateRandomBool() -> Bool {
    return generateRandomNumber(upTo: 1) == 0 ? true : false
}
