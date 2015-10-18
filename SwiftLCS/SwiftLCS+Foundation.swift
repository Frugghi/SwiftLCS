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

public extension CollectionType where Generator.Element : Equatable, Index: BidirectionalIndexType {
    
    /**
    Return the longest common subsequence between two collections.
    - parameter collection: The collection with which to compare the receiver.
    - complexity: O(mn) where `m` and `n` are the lengths of the receiver and the given collection.
    - returns: A tuple of `common`, `added` and `removed` indexes.
        - `common`: The indexes whose corresponding values in the receiver are in the LCS.
        - `added`: The indexes whose corresponding values in the given collection are not in the LCS.
        - `removed`: The indexes whose corresponding values in the receiver are not in the LCS.
    */
    @warn_unused_result
    public func longestCommonSubsequence(collection: Self) -> (common: NSIndexSet, added: NSIndexSet, removed: NSIndexSet) {
        let (common, added, removed): ([Index], [Index], [Index]) = self.longestCommonSubsequence(collection)

        return (common: self.toIndexSet(common), added: collection.toIndexSet(added), removed: self.toIndexSet(removed))
    }
    
    // MARK: - Private
    
    private func toIndexSet(indexes: [Index]) -> NSIndexSet {
        let indexSet = NSMutableIndexSet()
        indexes.forEach { index in
            var i = 0
            for var countIndex = self.startIndex; countIndex.distanceTo(index) > 0; countIndex = countIndex.successor() {
                i++
            }
            indexSet.addIndex(i)
        }
        
        return indexSet
    }
    
}
