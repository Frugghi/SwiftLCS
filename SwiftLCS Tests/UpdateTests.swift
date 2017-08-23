//
// The MIT License (MIT)
//
// Copyright (c) 2017 Jan Cislinsky
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

import XCTest
@testable import SwiftLCS

class UpdateTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSimple() {
        let old = ["b", "c", "d", "e", "f", "g", "h"]
        let new = ["i", "j", "C", "k", "e", "l", "G", "m"]
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [3])
        XCTAssertEqual(diff.updatedIndexes, [1, 5])
        XCTAssertEqual(diff.addedIndexes, [0, 1, 3, 5, 7])
        XCTAssertEqual(diff.removedIndexes, [0, 2, 4, 6])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testPrefix() {
        let old = ["b", "c", "d", "e", "f"]
        let new = ["B", "C", "d", "g", "h"]
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [2])
        XCTAssertEqual(diff.updatedIndexes, [0, 1])
        XCTAssertEqual(diff.addedIndexes, [3, 4])
        XCTAssertEqual(diff.removedIndexes, [3, 4])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testSuffix() {
        let old = ["b", "c", "d", "e", "f"]
        let new = ["g", "h", "d", "E", "F"]
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [2])
        XCTAssertEqual(diff.updatedIndexes, [3, 4])
        XCTAssertEqual(diff.addedIndexes, [0, 1])
        XCTAssertEqual(diff.removedIndexes, [0, 1])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testContains() {
        let old = ["b", "c", "d", "e", "f"]
        let new = ["g", "h", "b", "c", "D", "E", "f"]
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [0, 1, 4])
        XCTAssertEqual(diff.updatedIndexes, [2, 3])
        XCTAssertEqual(diff.addedIndexes, [0, 1])
        XCTAssertEqual(diff.removedIndexes, [])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testEqual() {
        let old = ["b", "c", "d", "e", "f"]
        let new = ["B", "C", "D", "E", "F"]
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [])
        XCTAssertEqual(diff.updatedIndexes, [0, 1, 2, 3, 4])
        XCTAssertEqual(diff.addedIndexes, [])
        XCTAssertEqual(diff.removedIndexes, [])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testEmpty() {
        let old = ["b", "c", "d", "e", "f"]
        let new = [String]()
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [])
        XCTAssertEqual(diff.updatedIndexes, [])
        XCTAssertEqual(diff.addedIndexes, [])
        XCTAssertEqual(diff.removedIndexes, [0, 1, 2, 3, 4])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testBothEmpty() {
        let old = [Int]()
        let new = [Int]()
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [])
        XCTAssertEqual(diff.updatedIndexes, [])
        XCTAssertEqual(diff.addedIndexes, [])
        XCTAssertEqual(diff.removedIndexes, [])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testDifferentLengths() {
        let old = ["b", "c", "d", "e", "f", "g"]
        let new = ["b", "g", "h", "C", "d"]
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [0, 2])
        XCTAssertEqual(diff.updatedIndexes, [1])
        XCTAssertEqual(diff.addedIndexes, [1, 2])
        XCTAssertEqual(diff.removedIndexes, [3, 4, 5])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testAddMultipleCopiesStart() {
        let old = ["a", "b", "c"]
        let new = ["d", "d", "A", "b", "C"]
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [1])
        XCTAssertEqual(diff.updatedIndexes, [0, 2])
        XCTAssertEqual(diff.addedIndexes, [0, 1])
        XCTAssertEqual(diff.removedIndexes, [])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testAddMultipleCopies() {
        let old = ["a", "b", "c"]
        let new = ["d", "a", "d", "C", "d"]
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [0])
        XCTAssertEqual(diff.updatedIndexes, [2])
        XCTAssertEqual(diff.addedIndexes, [0, 2, 4])
        XCTAssertEqual(diff.removedIndexes, [1])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testAddMultipleCopiesEnd() {
        let old = ["a", "b", "c"]
        let new = ["A", "b", "C", "d", "d"]
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [1])
        XCTAssertEqual(diff.updatedIndexes, [0, 2])
        XCTAssertEqual(diff.addedIndexes, [3, 4])
        XCTAssertEqual(diff.removedIndexes, [])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.updatedIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testNSIndexSet() {
        let old = ["b", "c", "d", "e", "f", "g", "h"]
        let new = ["i", "j", "c", "k", "E", "l", "g", "m"]
        let diff = Diff(old, new)
        
        let commonIndexSet = IndexSet([1, 5])
        XCTAssertEqual(diff.commonIndexSet, commonIndexSet)
        
        let updatedIndexSet = IndexSet([3])
        XCTAssertEqual(diff.updatedIndexSet, updatedIndexSet)
        
        let addedIndexSet = IndexSet([0, 1, 3, 5, 7])
        XCTAssertEqual(diff.addedIndexSet, addedIndexSet)
        
        let removedIndexSet = IndexSet([0, 2, 4, 6])
        XCTAssertEqual(diff.removedIndexSet, removedIndexSet)
    }

}
