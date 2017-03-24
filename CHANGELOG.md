# Changelog

## 1.1.1 (2017-03-24)

##### Breaking

* None.

##### Enhancements

* None.

##### Bug Fixes

* Fix issue where `addedIndexes` could contain the same index multiple times.
  [RaimarT](https://github.com/RaimarT)
  [#4](https://github.com/Frugghi/SwiftLCS/issues/4)

## 1.1 (2016-09-18)

##### Breaking

* None.

##### Enhancements

* Support for Swift 3.
* Improve performances.

##### Bug Fixes

* None.

## 1.0.1 (2016-04-25)

##### Breaking

* None.

##### Enhancements

* None.

##### Bug Fixes

* Fix Swift 3 warnings.

## 1.0 (2015-10-19)

#### CollectionType extension:
An extension of `CollectionType`, which calculates the diff between two collections.
* `diff()` returns the diff between two collections.

#### RangeReplaceableCollectionType extension:
An extension of `RangeReplaceableCollectionType`, which calculates the longest common subsequence between two collections.
* `longestCommonSubsequence()` returns the longest common subsequence between two collections.

#### String extension:
An extension of `String`, which calculates the longest common subsequence between two strings.
* `longestCommonSubsequence()` returns the longest common subsequence between two strings.

#### Diff struct:
A generic struct that represents a diff between two collections.
