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
An extension of `Diff`, which adds support for `Foundation` types such as `IndexSet`.
*/
public extension Diff where Index: Strideable, Index.Stride: SignedInteger {
    
    /// The indexes whose corresponding values in the old collection are in the LCS (have same identity).
    public var commonIndexSet: IndexSet {
        return toIndexSet(common)
    }
    
    /// The indexes whose corresponding values in the new collection are updated (have same identity, but different content) against old collection.
    public var updatedIndexSet: IndexSet {
        return toIndexSet(updated)
    }
    
    /// The indexes whose corresponding values in the new collection are not in the LCS.
    public var addedIndexSet: IndexSet {
        return toIndexSet(added)
    }
    
    /// The indexes whose corresponding values in the old collection are not in the LCS.
    public var removedIndexSet: IndexSet {
        return toIndexSet(removed)
    }
    
    // MARK: - Private
    
    fileprivate func toIndexSet(_ diff: (indexes: [Index], startIndex: Index)) -> IndexSet {
        let indexes = diff.indexes.map { Int((diff.startIndex..<$0).count.toIntMax()) }
        
        return IndexSet(indexes)
    }
    
}
