# SwiftLCS
[![Build Status](https://travis-ci.org/Frugghi/SwiftLCS.svg?branch=master)](https://travis-ci.org/Frugghi/SwiftLCS)
[![Pod documentation](https://img.shields.io/cocoapods/metrics/doc-percent/SwiftLCS.svg)](http://cocoadocs.org/docsets/SwiftLCS/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Pods](https://img.shields.io/cocoapods/v/SwiftLCS.svg)](https://cocoapods.org/pods/SwiftLCS)
[![Pod platforms](https://img.shields.io/cocoapods/p/SwiftLCS.svg)](https://cocoapods.org/pods/SwiftLCS)

SwitLCS provides an extension of `Collection` that finds the indexes of the longest common subsequence with another collection.

The **longest common subsequence** (LCS) problem is the problem of finding the longest subsequence common to all sequences in a set of sequences (often just two sequences). It differs from problems of finding common substrings: unlike substrings, subsequences are not required to occupy consecutive positions within the original sequences.

The project is based on the Objective-C implementation of [NSArray+LongestCommonSubsequence](https://github.com/khanlou/NSArray-LongestCommonSubsequence).

## :package: Installation

### CocoaPods
[CocoaPods](https://cocoapods.org) is the dependency manager for Swift and Objective-C Cocoa projects. It has over ten thousand libraries and can help you scale your projects elegantly.

Add this to your *Podfile*:
```Ruby
use_frameworks!

pod 'SwiftLCS'
```

### Carthage
[Carthage](https://github.com/Carthage/Carthage) builds your dependencies and provides you with binary frameworks, but you retain full control over your project structure and setup.

Add this to your *Cartfile*:
```Ruby
github "Frugghi/SwiftLCS"
```

### Swift Package Manager
The [Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

Add `SwiftLCS` to your *Package.swift* dependencies:
```Swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/Frugghi/SwiftLCS.git", majorVersion: 1, minor: 3)
    ]
)
```

### Manual
Include `SwiftLCS.swift` into your project.

## :book: Documentation
The API documentation is available [here](http://cocoadocs.org/docsets/SwiftLCS/).

## :computer: Usage
Import the framework:
```Swift
import SwiftLCS
```

### String
```Swift
let x = "abracadabra"
let y = "yabbadabbadoo"

let z = x.longestCommonSubsequence(y) // abadaba
```

### Array
```Swift
let x = [1, 2, 3, 4, 5, 6, 7]
let y = [8, 9, 2, 10, 4, 11, 6, 12]

let z = x.longestCommonSubsequence(y) // [2, 4, 6]
```

### Indexes
```Swift
let x = [1, 2, 3, 4, 5, 6, 7]
let y = [8, 9, 2, 10, 4, 11, 6, 12]

let diff = x.diff(y)
// diff.commonIndexes: [1, 3, 5]
// diff.addedIndexes: [0, 1, 3, 5, 7]
// diff.removedIndexes: [0, 2, 4, 6]
```

## :warning: Objective-C
[Object comparison](https://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/ObjectComparison.html) of Objective-C objects is done through the `isEquals:` method, so be sure that the implementations is correct otherwise `SwiftLCS` will not return the correct indexes.

## :page_facing_up: License [![LICENSE](https://img.shields.io/cocoapods/l/SwiftLCS.svg)](https://raw.githubusercontent.com/Frugghi/SwiftLCS/master/LICENSE)
*SwiftLCS* is released under the MIT license. See [LICENSE](https://raw.githubusercontent.com/Frugghi/SwiftLCS/master/LICENSE) for details.
