import XCTest

@testable import RecentValueCacheExample

final class RecentValueCacheTests: XCTestCase {
    func testReturnsNilForMissingKey() {
        let cache = RecentValueCache<String, Int>(capacity: 2)
        XCTAssertNil(cache.value(for: "missing"))
    }

    func testReturnsInsertedValue() {
        let cache = RecentValueCache<String, Int>(capacity: 2)
        cache.put(1, for: "a")
        XCTAssertEqual(cache.value(for: "a"), 1)
    }

    func testEvictsLeastRecentlyUsedKey() {
        let cache = RecentValueCache<String, Int>(capacity: 2)
        cache.put(1, for: "a")
        cache.put(2, for: "b")
        cache.put(3, for: "c")

        XCTAssertNil(cache.value(for: "a"))
        XCTAssertEqual(cache.value(for: "b"), 2)
        XCTAssertEqual(cache.value(for: "c"), 3)
    }

    func testReadRefreshesRecency() {
        let cache = RecentValueCache<String, Int>(capacity: 2)
        cache.put(1, for: "a")
        cache.put(2, for: "b")
        _ = cache.value(for: "a")
        cache.put(3, for: "c")

        XCTAssertNil(cache.value(for: "b"))
        XCTAssertEqual(cache.value(for: "a"), 1)
    }

    func testUpdateReplacesValueAndRefreshesRecency() {
        let cache = RecentValueCache<String, Int>(capacity: 2)
        cache.put(1, for: "a")
        cache.put(2, for: "b")
        cache.put(10, for: "a")
        cache.put(3, for: "c")

        XCTAssertNil(cache.value(for: "b"))
        XCTAssertEqual(cache.value(for: "a"), 10)
    }

    func testMissingReadDoesNotChangeRecency() {
        let cache = RecentValueCache<String, Int>(capacity: 2)
        cache.put(1, for: "a")
        cache.put(2, for: "b")
        _ = cache.value(for: "missing")
        cache.put(3, for: "c")

        XCTAssertNil(cache.value(for: "a"))
        XCTAssertEqual(cache.value(for: "b"), 2)
    }

    func testCapacityOneKeepsOnlyNewestKey() {
        let cache = RecentValueCache<String, Int>(capacity: 1)
        cache.put(1, for: "a")
        cache.put(2, for: "b")

        XCTAssertNil(cache.value(for: "a"))
        XCTAssertEqual(cache.value(for: "b"), 2)
    }

    func testStaysBoundedAcrossRepeatedEvictions() {
        let cache = RecentValueCache<String, Int>(capacity: 1)
        cache.put(1, for: "a")
        cache.put(2, for: "b")
        cache.put(3, for: "c")

        XCTAssertNil(cache.value(for: "b"))
        XCTAssertEqual(cache.value(for: "c"), 3)
    }

    func testSupportsNonStringKeysAndValues() {
        let cache = RecentValueCache<Int, [String]>(capacity: 2)
        cache.put(["one"], for: 1)
        cache.put(["two"], for: 2)

        XCTAssertEqual(cache.value(for: 1), ["one"])
        XCTAssertNil(cache.value(for: 3))
    }
}
