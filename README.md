# SwiftLCS
SwitLCS provides an extension of `CollectionType` that finds the indexes of the longest common subsequence with another collection.

The **longest common subsequence** (LCS) problem is the problem of finding the longest subsequence common to all sequences in a set of sequences (often just two sequences). It differs from problems of finding common substrings: unlike substrings, subsequences are not required to occupy consecutive positions within the original sequences.

The project is based on the Objective-C implementation of [NSArray+LongestCommonSubsequence](https://github.com/khanlou/NSArray-LongestCommonSubsequence).

## Usage

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

let (commonIndexes, addedIndexes, removedIndexes): ([Int], [Int], [Int]) = x.longestCommonSubsequence(y)
// commonIndexes: [1, 3, 5]
// addedIndexes: [0, 1, 3, 5, 7]
// removedIndexes: [0, 2, 4, 6]
```

## License
SwiftLCS is released under the MIT license. See LICENSE for details.
