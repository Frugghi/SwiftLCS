//
// The MIT License (MIT)
//
// Copyright (c) 2015 Tommaso Madonia
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

/**
A generic struct that represents a diff between two collections.
*/
public struct Diff<Index: BidirectionalIndexType> {
    
    /// The indexes whose corresponding values in the old collection are in the LCS.
    public var commonIndexes: [Index] {
        return self.common.indexes
    }
    
    /// The indexes whose corresponding values in the new collection are not in the LCS.
    public var addedIndexes: [Index] {
        return self.added.indexes
    }
    
    /// The indexes whose corresponding values in the old collection are not in the LCS.
    public var removedIndexes: [Index] {
        return self.removed.indexes
    }
    
    internal let common: (indexes: [Index], startIndex: Index)
    internal let added: (indexes: [Index], startIndex: Index)
    internal let removed: (indexes: [Index], startIndex: Index)
    
    /// Construct the `Diff` between two given collections.
    public init<C: CollectionType where C.Index == Index, C.Generator.Element: Equatable>(_ old: C, _ new: C) {
        self = old.diff(new)
    }
    
    private init<C: CollectionType where C.Index == Index>(common: ([Index], C), added: ([Index], C), removed: ([Index], C)) {
        self.common = (indexes: common.0, startIndex: common.1.startIndex)
        self.added = (indexes: added.0, startIndex: added.1.startIndex)
        self.removed = (indexes: removed.0, startIndex: removed.1.startIndex)
    }
    
}

/**
An extension of `CollectionType`, which calculates the diff between two collections.
*/
public extension CollectionType where Generator.Element: Equatable, Index: BidirectionalIndexType {

    /**
    Returns the diff between two collections.
    
    - complexity: O(mn) where `m` and `n` are the lengths of the receiver and the given collection.
    - parameter collection: The collection with which to compare the receiver.
    - returns: The diff between the receiver and the given collection.
    */
    @warn_unused_result
    public func diff(collection: Self) -> Diff<Index> {
        var lengths = Array2D(rows: Int(self.count.toIntMax()) + 1, columns: Int(collection.count.toIntMax()) + 1, repeatedValue: 0)
        for i in (self.startIndexWrapper..<self.endIndexWrapper).reverse() {
            for j in (collection.startIndexWrapper..<collection.endIndexWrapper).reverse() {
                if self[i] == collection[j] {
                    lengths[i, j] = lengths[i+1, j+1] + 1
                } else {
                    lengths[i, j] = max(lengths[i+1, j], lengths[i, j+1])
                }
            }
        }

        var commonIndexes = [Index]()

        var row = self.startIndexWrapper
        var column = collection.startIndexWrapper
        while row < lengths.rows - 1 && column < lengths.columns - 1 {
            if self[row] == collection[column] {
                commonIndexes.append(row)
                row = row.successor()
                column = column.successor()
            } else if lengths[row+1, column] >= lengths[row, column+1] {
                row = row.successor()
            } else {
                column = column.successor()
            }
        }

        let removedIndexes = self.map({ self.indexOf($0)! }).filter({ !commonIndexes.contains($0) })

        var addedIndexes = [Index]()
        var commonObjects = self.objectsAtIndexes(commonIndexes)
        for value in collection {
            if commonObjects.first == value {
                commonObjects.removeFirst()
            } else {
                addedIndexes.append(collection.indexOf(value)!)
            }
        }

        return Diff(common: (commonIndexes, self), added: (addedIndexes, collection), removed: (removedIndexes, self))
    }

}

/**
An extension of `RangeReplaceableCollectionType`, which calculates the longest common subsequence between two collections.
*/
public extension RangeReplaceableCollectionType where Generator.Element: Equatable, Index: BidirectionalIndexType {

    /**
    Returns the longest common subsequence between two collections.
    
    - parameter collection: The collection with which to compare the receiver.
    - returns: The longest common subsequence between the receiver and the given collection.
    */
    @warn_unused_result
    public func longestCommonSubsequence(collection: Self) -> Self {
        var subsequence = Self()

        let diff = self.diff(collection)
        diff.commonIndexes.forEach { index in
            subsequence.append(self[index])
        }

        return subsequence
    }

}

/**
An extension of `String`, which calculates the longest common subsequence between two strings.
*/
public extension String {

    /**
    Returns the longest common subsequence between two strings.
    
    - parameter string: The string with which to compare the receiver.
    - returns: The longest common subsequence between the receiver and the given string.
    */
    @warn_unused_result
    public func longestCommonSubsequence(string: String) -> String {
        return String(self.characters.longestCommonSubsequence(string.characters))
    }

}

// MARK: - Private structs/classes

private struct Array2D<Element> {

    private var matrix: [[Element]]
    var rows: Int {
        return self.matrix.count
    }
    var columns: Int {
        guard let firstRow = self.matrix.first else {
            return 0
        }

        return firstRow.count
    }

    init(rows: Int, columns: Int, repeatedValue: Element) {
        self.matrix = Array(count: rows, repeatedValue: Array(count: columns, repeatedValue: repeatedValue))
    }

    subscript(row: Int, column: Int) -> Element {
        get {
            return self.matrix[row][column]
        }
        set {
            self.matrix[row][column] = newValue
        }
    }

}

private struct IndexWrapper<IndexType: BidirectionalIndexType>: BidirectionalIndexType, Comparable {

    private(set) var firstIndex: Int
    private(set) var secondIndex: IndexType

    init(_ firstIndex: Int, _ secondIndex: IndexType) {
        self.firstIndex = firstIndex
        self.secondIndex = secondIndex
    }

    func successor() -> IndexWrapper {
        return IndexWrapper(self.firstIndex.successor(), self.secondIndex.successor())
    }

    func predecessor() -> IndexWrapper {
        return IndexWrapper(self.firstIndex.predecessor(), self.secondIndex.predecessor())
    }

}

// MARK: - Private protocols

private protocol IntValue {
    
    var intValue: Int { get }
    
}

// MARK: - Private operators

private func ==<T>(lhs: IndexWrapper<T>, rhs: IndexWrapper<T>) -> Bool {
    return lhs.firstIndex.intValue == rhs.firstIndex.intValue
}

private func <<T>(lhs: IndexWrapper<T>, rhs: IndexWrapper<T>) -> Bool {
    return lhs.firstIndex.intValue < rhs.firstIndex.intValue
}

private func <(lhs: IntValue, rhs: Int) -> Bool {
    return lhs.intValue < rhs
}

private func +(lhs: IntValue, rhs: Int) -> Int {
    return lhs.intValue + rhs
}

// MARK: - Private extensions

extension Int: IntValue {
    
    var intValue: Int {
        return self
    }
    
}

extension IndexWrapper: IntValue {

    var intValue: Int {
        return self.firstIndex.intValue
    }
    
}

private extension Array2D {

    subscript(row: IntValue, column: IntValue) -> Element {
        get {
            return self.matrix[row][column]
        }
        set {
            self.matrix[row][column] = newValue
        }
    }

}

private extension CollectionType where Index: BidirectionalIndexType {

    var startIndexWrapper: IndexWrapper<Index> {
        return IndexWrapper(0, self.startIndex)
    }

    var endIndexWrapper: IndexWrapper<Index> {
        return IndexWrapper(Int(self.count.toIntMax()), self.endIndex)
    }

    subscript(index: IndexWrapper<Index>) -> Generator.Element {
        return self[index.secondIndex]
    }

}

private extension CollectionType where Generator.Element : Equatable {

    func objectsAtIndexes(indexes: [Index]) -> [Generator.Element] {
        return self.filter({ indexes.contains(self.indexOf($0)!) })
    }

}

private extension Array {

    subscript(index: IntValue) -> Element {
        get {
            return self[index.intValue]
        }
        set {
            self[index.intValue] = newValue
        }
    }

}

private extension Array where Element: BidirectionalIndexType {
    
    mutating func append(index: IndexWrapper<Element>) {
        self.append(index.secondIndex)
    }
    
}
