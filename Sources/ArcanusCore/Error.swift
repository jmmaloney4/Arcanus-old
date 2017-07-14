// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public enum ARError: Error {
    case cardForNameDoesNotExist(String)
    case cardForDbfIDDoesNotExist(Int)
    case readingFileFailed(path: String)
    case invalidFormat

    case invalidResponse
    case notEnoughMana
    case invalidTarget
    
    case invalidInput
}
