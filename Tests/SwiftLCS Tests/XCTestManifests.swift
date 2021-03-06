#if !canImport(ObjectiveC)
import XCTest

extension ArrayTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ArrayTests = [
        ("testAppend", testAppend),
        ("testBothEmpty", testBothEmpty),
        ("testBothSingle", testBothSingle),
        ("testContains", testContains),
        ("testDifferentLengths", testDifferentLengths),
        ("testEmpty", testEmpty),
        ("testEqual", testEqual),
        ("testPrefix", testPrefix),
        ("testPrependAndAppend", testPrependAndAppend),
        ("testSimple", testSimple),
        ("testSuffix", testSuffix),
    ]
}

extension BenchmarkTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__BenchmarkTests = [
        ("testBenchmark100", testBenchmark100),
        ("testBenchmark1000", testBenchmark1000),
        ("testBenchmark2000", testBenchmark2000),
    ]
}

extension IndexTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__IndexTests = [
        ("testAddMultipleCopies", testAddMultipleCopies),
        ("testAddMultipleCopiesEnd", testAddMultipleCopiesEnd),
        ("testAddMultipleCopiesStart", testAddMultipleCopiesStart),
        ("testBothEmpty", testBothEmpty),
        ("testContains", testContains),
        ("testDifferentLengths", testDifferentLengths),
        ("testEmpty", testEmpty),
        ("testEqual", testEqual),
        ("testNSIndexSet", testNSIndexSet),
        ("testPrefix", testPrefix),
        ("testSimple", testSimple),
        ("testSuffix", testSuffix),
    ]
}

extension LinkedListTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__LinkedListTests = [
        ("testAddMultipleCopies", testAddMultipleCopies),
        ("testAddMultipleCopiesEnd", testAddMultipleCopiesEnd),
        ("testAddMultipleCopiesStart", testAddMultipleCopiesStart),
        ("testBothEmpty", testBothEmpty),
        ("testContains", testContains),
        ("testDifferentLengths", testDifferentLengths),
        ("testEmpty", testEmpty),
        ("testEqual", testEqual),
        ("testPrefix", testPrefix),
        ("testSimple", testSimple),
        ("testSuffix", testSuffix),
    ]
}

extension StringTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__StringTests = [
        ("testBothEmpty", testBothEmpty),
        ("testBothSingle", testBothSingle),
        ("testContains", testContains),
        ("testDifferentLengths", testDifferentLengths),
        ("testEmpty", testEmpty),
        ("testEqual", testEqual),
        ("testPrefix", testPrefix),
        ("testSimple", testSimple),
        ("testSuffix", testSuffix),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ArrayTests.__allTests__ArrayTests),
        testCase(BenchmarkTests.__allTests__BenchmarkTests),
        testCase(IndexTests.__allTests__IndexTests),
        testCase(LinkedListTests.__allTests__LinkedListTests),
        testCase(StringTests.__allTests__StringTests),
    ]
}
#endif
