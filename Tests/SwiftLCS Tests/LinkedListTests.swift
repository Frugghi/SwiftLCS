//
// The MIT License (MIT)
//
// Copyright (c) 2018 Tommaso Madonia
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

class LinkedListTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSimple() {
        let old: LinkedList<Int> = [1, 2, 3, 4, 5, 6, 7]
        let new: LinkedList<Int> = [8, 9, 2, 10, 4, 11, 6, 12]
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [1, 3, 5])
        XCTAssertEqual(diff.addedIndexes, [0, 1, 3, 5, 7])
        XCTAssertEqual(diff.removedIndexes, [0, 2, 4, 6])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testPrefix() {
        let old: LinkedList<Int> = [1, 2, 3, 4, 5]
        let new: LinkedList<Int> = [1, 2, 3, 6, 7]
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [0, 1, 2])
        XCTAssertEqual(diff.addedIndexes, [3, 4])
        XCTAssertEqual(diff.removedIndexes, [3, 4])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testSuffix() {
        let old: LinkedList<Int> = [1, 2, 3, 4, 5]
        let new: LinkedList<Int> = [6, 7, 3, 4, 5]
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [2, 3, 4])
        XCTAssertEqual(diff.addedIndexes, [0, 1])
        XCTAssertEqual(diff.removedIndexes, [0, 1])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testContains() {
        let old: LinkedList<Int> = [1, 2, 3, 4, 5]
        let new: LinkedList<Int> = [6, 7, 1, 2, 3, 4, 5]
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [0, 1, 2, 3, 4])
        XCTAssertEqual(diff.addedIndexes, [0, 1])
        XCTAssertEqual(diff.removedIndexes, [])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testEqual() {
        let old: LinkedList<Int> = [1, 2, 3, 4, 5]
        let new: LinkedList<Int> = [1, 2, 3, 4, 5]
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [0, 1, 2, 3, 4])
        XCTAssertEqual(diff.addedIndexes, [])
        XCTAssertEqual(diff.removedIndexes, [])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testEmpty() {
        let old: LinkedList<Int> = [1, 2, 3, 4, 5]
        let new: LinkedList<Int> = []
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [])
        XCTAssertEqual(diff.addedIndexes, [])
        XCTAssertEqual(diff.removedIndexes, [0, 1, 2, 3, 4])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testBothEmpty() {
        let old: LinkedList<Int> = []
        let new: LinkedList<Int> = []
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [])
        XCTAssertEqual(diff.addedIndexes, [])
        XCTAssertEqual(diff.removedIndexes, [])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testDifferentLengths() {
        let old: LinkedList<Int> = [1, 2, 3, 4, 5, 6]
        let new: LinkedList<Int> = [1, 6, 7, 2, 3]
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [0, 1, 2])
        XCTAssertEqual(diff.addedIndexes, [1, 2])
        XCTAssertEqual(diff.removedIndexes, [3, 4, 5])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testAddMultipleCopiesStart() {
        let old: LinkedList<Int> = [0, 1, 2]
        let new: LinkedList<Int> = [3, 3, 0, 1, 2]
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [0, 1, 2])
        XCTAssertEqual(diff.addedIndexes, [0, 1])
        XCTAssertEqual(diff.removedIndexes, [])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testAddMultipleCopies() {
        let old: LinkedList<Int> = [0, 1, 2]
        let new: LinkedList<Int> = [3, 0, 3, 2, 3]
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [0, 2])
        XCTAssertEqual(diff.addedIndexes, [0, 2, 4])
        XCTAssertEqual(diff.removedIndexes, [1])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.addedIndexes.count, new.count)
    }
    
    func testAddMultipleCopiesEnd() {
        let old: LinkedList<Int> = [0, 1, 2]
        let new: LinkedList<Int> = [0, 1, 2, 3, 3]
        let diff = Diff(old, new)
        
        XCTAssertEqual(diff.commonIndexes, [0, 1, 2])
        XCTAssertEqual(diff.addedIndexes, [3, 4])
        XCTAssertEqual(diff.removedIndexes, [])
        
        XCTAssertEqual(diff.commonIndexes.count + diff.removedIndexes.count, old.count)
        XCTAssertEqual(diff.commonIndexes.count + diff.addedIndexes.count, new.count)
    }
    
}

// MARK: - Linked list -

/// Ugly implementation of a linked list, used for testing non bidirectional collections
fileprivate class LinkedList<T> : Collection, ExpressibleByArrayLiteral {
    typealias Index = Int
    typealias SubSequence = LinkedList<T>
    
    private var head: LinkedListNode<T>?
    
    var startIndex: Int {
        return 0
    }
    
    var endIndex: Int {
        return self.count
    }
    
    var count: Int {
        var count = 0
        var nextNode = self.head
        while nextNode != nil {
            nextNode = nextNode?.next
            count += 1
        }
        return count
    }
    
    func index(after i: Int) -> Int {
        return i + 1
    }
    
    subscript(index: Int) -> T {
        var count = 0
        var nextNode = self.head
        while count != index || nextNode == nil {
            nextNode = nextNode?.next
            count += 1
        }
        return nextNode!.element
    }
    
    required init(arrayLiteral elements: T...) {
        var lastNode = self.head
        for element in elements {
            let node = LinkedListNode(element: element)
            if lastNode != nil {
                lastNode?.next = node
            } else {
                self.head = node
            }
            lastNode = node
        }
    }
    
    
    private class LinkedListNode<T> {
        
        var element: T
        var next: LinkedListNode<T>?
        
        init(element: T, next: LinkedListNode<T>? = nil) {
            self.element = element
            self.next = next
        }
        
    }
    
}

