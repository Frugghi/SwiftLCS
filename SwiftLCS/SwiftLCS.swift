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
public struct Diff<Index: Comparable> {
    
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
    public init<C: Collection>(_ old: C, _ new: C) where C.Index == Index, C.Iterator.Element: Equatable {
        self = old.diff(new)
    }
    
    fileprivate init<C: Collection>(common: ([Index], C), added: ([Index], C), removed: ([Index], C)) where C.Index == Index {
        self.common = (indexes: common.0, startIndex: common.1.startIndex)
        self.added = (indexes: added.0, startIndex: added.1.startIndex)
        self.removed = (indexes: removed.0, startIndex: removed.1.startIndex)
    }
    
}

/**
An extension of `CollectionType`, which calculates the diff between two collections.
*/
public extension Collection where Iterator.Element: Equatable, Index: Comparable {

    /**
    Returns the diff between two collections.
    
    - complexity: O(mn) where `m` and `n` are the lengths of the receiver and the given collection.
    - parameter collection: The collection with which to compare the receiver.
    - returns: The diff between the receiver and the given collection.
    */
    
    public func diff(_ otherCollection: Self) -> Diff<Index> {
        let rows = Int(self.count.toIntMax()) + 1
        let columns = Int(otherCollection.count.toIntMax()) + 1
        var lengths = Array(repeating: Array(repeating: 0, count: columns), count: rows)
        for (i, element) in self.enumerated().reversed() {
            for (j, otherElement) in otherCollection.enumerated().reversed() {
                if element == otherElement {
                    lengths[i][j] = lengths[i+1][j+1] + 1
                } else {
                    lengths[i][j] =  [ lengths[i+1][j], lengths[i][j+1] ].max()!
                }
            }
        }

        var commonIndexes = [Index]()

        var index = self.startIndex
        var iterator = self.enumerated().makeIterator()
        var otherIterator = otherCollection.enumerated().makeIterator()
        
        var entry = iterator.next()
        var otherEntry = otherIterator.next()
        while entry != nil && otherEntry != nil {
            let i = entry!.offset
            let j = otherEntry!.offset
            
            if entry!.element == otherEntry!.element {
                commonIndexes.append(index)
                index = self.index(after: index)
                entry = iterator.next()
                otherEntry = otherIterator.next()
            } else if lengths[i+1][j] >= lengths[i][j+1] {
                index = self.index(after: index)
                entry = iterator.next()
            } else {
                otherEntry = otherIterator.next()
            }
        }
        
        let removedIndexes = self.map { self.index(of: $0)! }.filter { !commonIndexes.contains($0) }

        var addedIndexes = [Index]()
        var commonObjects = self.filter { commonIndexes.contains(self.index(of: $0)!) }
        for value in otherCollection {
            if commonObjects.first == value {
                commonObjects.removeFirst()
            } else {
                addedIndexes.append(otherCollection.index(of: value)!)
            }
        }

        return Diff(common: (commonIndexes, self), added: (addedIndexes, otherCollection), removed: (removedIndexes, self))
    }

}

/**
An extension of `RangeReplaceableCollectionType`, which calculates the longest common subsequence between two collections.
*/
public extension RangeReplaceableCollection where Iterator.Element: Equatable, Index: Comparable {

    /**
    Returns the longest common subsequence between two collections.
    
    - parameter collection: The collection with which to compare the receiver.
    - returns: The longest common subsequence between the receiver and the given collection.
    */
    
    public func longestCommonSubsequence(_ collection: Self) -> Self {
        return Self(self.diff(collection).commonIndexes.map { self[$0] })
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
    
    public func longestCommonSubsequence(_ string: String) -> String {
        return String(self.characters.longestCommonSubsequence(string.characters))
    }

}
