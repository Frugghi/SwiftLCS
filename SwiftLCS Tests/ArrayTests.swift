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

class ArrayTests: XCTestCase {

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
        XCTAssertEqual(old.longestCommonSubsequence(new), [2, 4, 6])
    }

    func testPrefix() {
        let old = [1, 2, 3, 4, 5]
        let new = [1, 2, 3, 6, 7]
        XCTAssertEqual(old.longestCommonSubsequence(new), [1, 2, 3])
    }

    func testSuffix() {
        let old = [1, 2, 3, 4, 5]
        let new = [6, 7, 3, 4, 5]
        XCTAssertEqual(old.longestCommonSubsequence(new), [3, 4, 5])
    }
    
    func testContains() {
        let old = [1, 2, 3, 4, 5]
        let new = [6, 7, 1, 2, 3, 4, 5]
        XCTAssertEqual(old.longestCommonSubsequence(new), [1, 2, 3, 4, 5])
    }

    func testEqual() {
        let old = [1, 2, 3, 4, 5]
        let new = [1, 2, 3, 4, 5]
        XCTAssertEqual(old.longestCommonSubsequence(new), [1, 2, 3, 4, 5])
    }

    func testEmpty() {
        let old = [1, 2, 3, 4, 5]
        let new = [Int]()
        XCTAssertEqual(old.longestCommonSubsequence(new), [Int]())
        XCTAssertEqual(new.longestCommonSubsequence(old), [Int]())
    }
    
    func testBothEmpty() {
        let old = [Int]()
        let new = [Int]()
        XCTAssertEqual(old.longestCommonSubsequence(new), [Int]())
        XCTAssertEqual(new.longestCommonSubsequence(old), [Int]())
    }

    func testBothSingle() {
        let old = [1]
        let new = [1]
        XCTAssertEqual(old.longestCommonSubsequence(new), [1])
        XCTAssertEqual(new.longestCommonSubsequence(old), [1])
    }
    
    func testDifferentLengths() {
        let old = [1, 2, 3, 4, 5, 6]
        let new = [1, 6, 7, 2, 3]
        XCTAssertEqual(old.longestCommonSubsequence(new), [1, 2, 3])
        XCTAssertEqual(new.longestCommonSubsequence(old), [1, 2, 3])
    }
    
    func testAppend() {
        let old = [1, 2, 3, 4, 5, 6, 7]
        let new = old + [8, 9, 10, 11]
        XCTAssertEqual(old.longestCommonSubsequence(new), [1, 2, 3, 4, 5, 6, 7])
    }
    
    func testPrependAndAppend() {
        let old = [1, 2, 3, 4, 5, 6, 7]
        let new = [0] + old + [8, 9, 10, 11]
        XCTAssertEqual(old.longestCommonSubsequence(new), [1, 2, 3, 4, 5, 6, 7])
    }

}
