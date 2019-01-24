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

import Foundation

/**
A generic struct that represents a diff between two collections.
*/
public struct Diff<Index> {
    
    /// The indexes whose corresponding values in the old collection are in the LCS.
    public var commonIndexes: [Index] {
        return self._commonIndexSet.indexes
    }
    
    /// The indexes whose corresponding values in the new collection are not in the LCS.
    public var addedIndexes: [Index] {
        return self._addedIndexSet.indexes
    }
    
    /// The indexes whose corresponding values in the old collection are not in the LCS.
    public var removedIndexes: [Index] {
        return self._removedIndexSet.indexes
    }
    
    /// Construct the `Diff` between two given collections.
    public init<C: Collection>(_ old: C, _ new: C) where C.Index == Index, C.Element: Equatable {
        self = old.diff(new)
    }
    
    fileprivate let _commonIndexSet: DiffIndexSet<Index>
    fileprivate let _addedIndexSet: DiffIndexSet<Index>
    fileprivate let _removedIndexSet: DiffIndexSet<Index>
    
    fileprivate init(commonIndexes: DiffIndexSet<Index>, addedIndexes: DiffIndexSet<Index>, removedIndexes: DiffIndexSet<Index>) {
        self._commonIndexSet = commonIndexes
        self._addedIndexSet = addedIndexes
        self._removedIndexSet = removedIndexes
    }
    
}

/**
 An extension of `Diff`, which adds support for `IndexSet`.
 */
public extension Diff where Index: Strideable, Index.Stride: SignedInteger {
    
    /// The indexes whose corresponding values in the old collection are in the LCS.
    public var commonIndexSet: IndexSet {
        return self._commonIndexSet.indexSet
    }
    
    /// The indexes whose corresponding values in the new collection are not in the LCS.
    public var addedIndexSet: IndexSet {
        return self._addedIndexSet.indexSet
    }
    
    /// The indexes whose corresponding values in the old collection are not in the LCS.
    public var removedIndexSet: IndexSet {
        return self._removedIndexSet.indexSet
    }
    
}

private struct DiffIndexSet<Index> {
    
    let startIndex: Index
    let indexes: [Index]
    
    init(_ indexes: [Index], startIndex: Index) {
        self.indexes = indexes
        self.startIndex = startIndex
    }
    
}

private extension DiffIndexSet where Index: Strideable, Index.Stride: SignedInteger {
    
    var indexSet: IndexSet {
        let indexes = self.indexes.map { Int((self.startIndex..<$0).count) }
        
        return IndexSet(indexes)
    }
    
}

// MARK: -

/**
An extension of `Collection`, which calculates the diff between two collections.
*/
public extension Collection where Element: Equatable {

    /**
    Returns the diff between two collections.
    
    - complexity: O(mn) where `m` and `n` are the lengths of the receiver and the given collection.
    - parameter collection: The collection with which to compare the receiver.
    - returns: The diff between the receiver and the given collection.
    */
    public func diff(_ otherCollection: Self) -> Diff<Index> {
        let count = self.count
        let commonIndexes = self.longestCommonSubsequence(otherCollection, selfCount: count)

        var removedIndexes: [Index] = []
        removedIndexes.reserveCapacity(count - commonIndexes.count)
        
        var addedIndexes: [Index] = []
        
        var index = self.startIndex
        var otherIndex = otherCollection.startIndex
        var commonIndexesIterator = commonIndexes.makeIterator()
        var commonIndex = commonIndexesIterator.next()
        while index != self.endIndex {
            if commonIndex == index {
                commonIndex = commonIndexesIterator.next()
                
                while otherIndex != otherCollection.endIndex && otherCollection[otherIndex] != self[index] {
                    addedIndexes.append(otherIndex)
                    otherIndex = otherCollection.index(after: otherIndex)
                }
                
                if otherIndex != otherCollection.endIndex {
                    otherIndex = otherCollection.index(after: otherIndex)
                }
            } else {
                removedIndexes.append(index)
            }
            
            index = self.index(after: index)
        }
        
        while otherIndex != otherCollection.endIndex {
            addedIndexes.append(otherIndex)
            otherIndex = otherCollection.index(after: otherIndex)
        }
        
        return Diff(commonIndexes: DiffIndexSet(commonIndexes, startIndex: self.startIndex),
                    addedIndexes: DiffIndexSet(addedIndexes, startIndex: otherCollection.startIndex),
                    removedIndexes: DiffIndexSet(removedIndexes, startIndex: self.startIndex))
    }
    
    // MARK: Private functions
    
    private func prefix(_ otherCollection: Self, count: Int, suffix: Int) -> (Int, [Index]) {
        var iterator = self.makeIterator()
        var otherIterator = otherCollection.makeIterator()
        
        var prefix = self.startIndex
        let endIndex = self.index(self.startIndex, offsetBy: count - suffix)
        while let lhs = iterator.next(), let rhs = otherIterator.next(), lhs == rhs, prefix < endIndex {
            prefix = self.index(after: prefix)
        }
        
        let prefixLength = self.distance(from: self.startIndex, to: prefix)
        return (prefixLength, Array(self.indices.prefix(prefixLength)))
    }
    
    private func suffix(_ otherCollection: Self, count: Int) -> (Int, [Index]) {
        var iterator = self.reversed().makeIterator()
        var otherIterator = otherCollection.reversed().makeIterator()
        
        var offset = count
        var suffix = self.index(self.startIndex, offsetBy: offset)
        while let lhs = iterator.next(), let rhs = otherIterator.next(), lhs == rhs {
            offset &-= 1
            suffix = self.index(self.startIndex, offsetBy: offset)
        }
        
        let suffixLength = self.distance(from: suffix, to: self.endIndex)
        return (suffixLength, Array(self.indices.suffix(suffixLength)))
    }
    
    private func computeLCS(_ otherCollection: Self, prefixLength: Int, suffixLength: Int, count: Int) -> [Index] {
        let rows = Int(count - prefixLength - suffixLength) + 1
        let columns = Int(otherCollection.count - prefixLength - suffixLength) + 1
        
        guard rows > 1 && columns > 1 else {
            return []
        }
        
        var lengths = Array(repeating: 0, count: rows * columns)
        var index = self.index(self.startIndex, offsetBy: prefixLength)
        for i in 0..<rows &- 1 {
            var otherIndex = otherCollection.index(otherCollection.startIndex, offsetBy: prefixLength)
            for j in 0..<columns &- 1 {
                if self[index] == otherCollection[otherIndex] {
                    lengths[(i &+ 1) &* columns &+ j &+ 1] = lengths[i &* columns &+ j] &+ 1
                } else {
                    let lhs = lengths[(i &+ 1) &* columns &+ j]
                    let rhs = lengths[i &* columns &+ j &+ 1]
                    lengths[(i &+ 1) &* columns &+ j &+ 1] = Swift.max(lhs, rhs)
                }
                
                otherIndex = otherCollection.index(after: otherIndex)
            }
            
            index = self.index(after: index)
        }
        
        var commonIndexes: [Index] = []
        
        var indexOffset = count - suffixLength
        index = self.index(self.startIndex, offsetBy: indexOffset)
        var (i, j) = (rows &- 1, columns &- 1)
        while i != 0 && j != 0 {
            if lengths[i &* columns &+ j] == lengths[(i &- 1) &* columns &+ j] {
                i = i &- 1
                indexOffset &-= 1
                index = self.index(self.startIndex, offsetBy: indexOffset)
            } else if lengths[i &* columns &+ j] == lengths[i &* columns &+ j &- 1] {
                j = j &- 1
            } else {
                indexOffset &-= 1
                index = self.index(self.startIndex, offsetBy: indexOffset)
                commonIndexes.append(index)
                (i, j) = (i &- 1, j &- 1)
            }
        }
        
        return commonIndexes.reversed()
    }
    
    fileprivate func longestCommonSubsequence(_ otherCollection: Self, selfCount count: Int) -> [Index] {
        let (suffix, suffixIndexes) = self.suffix(otherCollection, count: count)
        let (prefix, prefixIndexes) = self.prefix(otherCollection, count: count, suffix: suffix)
        
        return prefixIndexes + self.computeLCS(otherCollection, prefixLength: prefix, suffixLength: suffix, count: count) + suffixIndexes
    }

}

// MARK: -

/**
An extension of `RangeReplaceableCollection`, which calculates the longest common subsequence between two collections.
*/
public extension RangeReplaceableCollection where Element: Equatable {

    /**
    Returns the longest common subsequence between two collections.
    
    - parameter collection: The collection with which to compare the receiver.
    - returns: The longest common subsequence between the receiver and the given collection.
    */
    public func longestCommonSubsequence(_ collection: Self) -> Self {
        return Self(self.longestCommonSubsequence(collection, selfCount: self.count).map { self[$0] })
    }

}
