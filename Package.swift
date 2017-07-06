// Copyright © 2017 Jack Maloney. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import PackageDescription


/* Swift 4 ----------

let package = Package(
    name: "Arcanus",
    products: [
        .library(name: "Arcanus", targets: ["Arcanus"]),
        .executable(name:"arcanus", targets: ["CLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/jmmaloney4/Squall.git", .upToNextMinor("1.2.1")),
        ],
    targets: [
        .target(
            name: "CLI",
            dependencies: [
                "Arcanus"
            ]
        ),
        .target(
            name: "Arcanus",
            dependencies: [
                "Squall"
            ]
        ),
        .testTarget(
            name: "ArcanusTests",
            dependencies: [
                "Arcanus"
            ]
        )
    ]
)

*/

let package = Package(
    name: "Arcanus",
    targets: [ Target(name: "CLI", dependencies: ["Arcanus"]) ],

    dependencies: [
        .Package(url: "https://github.com/jmmaloney4/Squall.git", versions: Version(1,2,2)..<Version(1,3,0)),
    ]
)
