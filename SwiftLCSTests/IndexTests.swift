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

import XCTest
@testable import SwiftLCS

class IndexTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSimple() {
        let old = [1, 2, 3, 4, 5, 6, 7]
        let new = [8, 9, 2, 10, 4, 11, 6, 12]
        let diff = old.diff(new)

        XCTAssertEqual(diff.commonIndexes, [1, 3, 5])
        XCTAssertEqual(diff.addedIndexes, [0, 1, 3, 5, 7])
        XCTAssertEqual(diff.removedIndexes, [0, 2, 4, 6])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.addedIndexes.count, new.count)
    }

    func testPrefix() {
        let old = [1, 2, 3, 4, 5]
        let new = [1, 2, 3, 6, 7]
        let diff = old.diff(new)

        XCTAssertEqual(diff.commonIndexes, [0, 1, 2])
        XCTAssertEqual(diff.addedIndexes, [3, 4])
        XCTAssertEqual(diff.removedIndexes, [3, 4])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.addedIndexes.count, new.count)
    }

    func testSuffix() {
        let old = [1, 2, 3, 4, 5]
        let new = [6, 7, 3, 4, 5]
        let diff = old.diff(new)

        XCTAssertEqual(diff.commonIndexes, [2, 3, 4])
        XCTAssertEqual(diff.addedIndexes, [0, 1])
        XCTAssertEqual(diff.removedIndexes, [0, 1])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.addedIndexes.count, new.count)
    }

    func testEqual() {
        let old = [1, 2, 3, 4, 5]
        let new = [1, 2, 3, 4, 5]
        let diff = old.diff(new)

        XCTAssertEqual(diff.commonIndexes, [0, 1, 2, 3, 4])
        XCTAssertEqual(diff.addedIndexes, [])
        XCTAssertEqual(diff.removedIndexes, [])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.addedIndexes.count, new.count)
    }

    func testEmpty() {
        let old = [1, 2, 3, 4, 5]
        let new = [Int]()
        let diff = old.diff(new)

        XCTAssertEqual(diff.commonIndexes, [])
        XCTAssertEqual(diff.addedIndexes, [])
        XCTAssertEqual(diff.removedIndexes, [0, 1, 2, 3, 4])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testBothEmpty() {
        let old = [Int]()
        let new = [Int]()
        let diff = old.diff(new)
        
        XCTAssertEqual(diff.commonIndexes, [])
        XCTAssertEqual(diff.addedIndexes, [])
        XCTAssertEqual(diff.removedIndexes, [])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.addedIndexes.count, new.count)
    }

    func testDifferentLengths() {
        let old = [1, 2, 3, 4, 5, 6]
        let new = [1, 6, 7, 2, 3]
        let diff = old.diff(new)

        XCTAssertEqual(diff.commonIndexes, [0, 1, 2])
        XCTAssertEqual(diff.addedIndexes, [1, 2])
        XCTAssertEqual(diff.removedIndexes, [3, 4, 5])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testNSIndexSet() {
        let old = [1, 2, 3, 4, 5, 6, 7]
        let new = [8, 9, 2, 10, 4, 11, 6, 12]
        let diff = old.diff(new)
        
        let commonIndexSet = NSMutableIndexSet()
        commonIndexSet.addIndex(1)
        commonIndexSet.addIndex(3)
        commonIndexSet.addIndex(5)
        XCTAssertEqual(diff.commonIndexSet, commonIndexSet)
        
        let addedIndexSet = NSMutableIndexSet()
        addedIndexSet.addIndex(0)
        addedIndexSet.addIndex(1)
        addedIndexSet.addIndex(3)
        addedIndexSet.addIndex(5)
        addedIndexSet.addIndex(7)
        XCTAssertEqual(diff.addedIndexSet, addedIndexSet)
        
        let removedIndexSet = NSMutableIndexSet()
        removedIndexSet.addIndex(0)
        removedIndexSet.addIndex(2)
        removedIndexSet.addIndex(4)
        removedIndexSet.addIndex(6)
        XCTAssertEqual(diff.removedIndexSet, removedIndexSet)
    }

}
