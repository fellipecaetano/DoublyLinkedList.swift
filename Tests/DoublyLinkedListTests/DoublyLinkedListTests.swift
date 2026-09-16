import XCTest

@testable import DoublyLinkedList

final class DoublyLinkedListTests: XCTestCase {
    func testNewListIsEmpty() {
        let list = DoublyLinkedList<String, Int>()

        XCTAssertNil(list.head)
        XCTAssertTrue(list.keys.isEmpty)
        XCTAssertTrue(list.values.isEmpty)
    }

    func testAppendPreservesInsertionOrder() {
        let list = DoublyLinkedList<String, Int>()
        list.append(key: "a", value: 1)
        list.append(key: "b", value: 2)
        list.append(key: "c", value: 3)

        XCTAssertEqual(list.keys, ["a", "b", "c"])
        XCTAssertEqual(list.values, [1, 2, 3])
        XCTAssertEqual(list.head?.key, "a")
    }

    func testMapTransformsPairsInOrder() {
        let list = DoublyLinkedList<String, Int>()
        list.append(key: "a", value: 1)
        list.append(key: "b", value: 2)

        XCTAssertEqual(list.map { key, value in "\(key):\(value)" }, ["a:1", "b:2"])
    }

    func testRemoveByKeyReturnsUnlinkedNode() {
        let list = DoublyLinkedList<String, Int>()
        list.append(key: "a", value: 1)
        list.append(key: "b", value: 2)
        list.append(key: "c", value: 3)

        let removed = list.remove(key: "b")

        XCTAssertEqual(removed?.key, "b")
        XCTAssertEqual(removed?.value, 2)
        XCTAssertEqual(list.keys, ["a", "c"])
        XCTAssertEqual(list.values, [1, 3])
    }

    func testRemoveByMissingKeyLeavesListIntact() {
        let list = DoublyLinkedList<String, Int>()
        list.append(key: "a", value: 1)

        XCTAssertNil(list.remove(key: "missing"))
        XCTAssertEqual(list.keys, ["a"])
    }

    func testRemoveHeadAdvancesHead() {
        let list = DoublyLinkedList<String, Int>()
        list.append(key: "a", value: 1)
        list.append(key: "b", value: 2)

        list.remove(key: "a")

        XCTAssertEqual(list.head?.key, "b")
        XCTAssertEqual(list.keys, ["b"])
    }

    func testRemoveTailKeepsRemainingOrder() {
        let list = DoublyLinkedList<String, Int>()
        list.append(key: "a", value: 1)
        list.append(key: "b", value: 2)

        list.remove(key: "b")

        XCTAssertEqual(list.keys, ["a"])
        XCTAssertEqual(list.head?.key, "a")
    }

    func testReappendingRemovedNodeMovesItToTail() {
        let list = DoublyLinkedList<String, Int>()
        list.append(key: "a", value: 1)

        let node = list.append(key: "b", value: 2)
        list.remove(node: node)
        list.append(node: node)

        XCTAssertEqual(list.keys, ["a", "b"])
        XCTAssertEqual(list.values, [1, 2])
    }

    func testRemovingEveryNodeEmptiesList() {
        let list = DoublyLinkedList<String, Int>()
        list.append(key: "a", value: 1)
        list.append(key: "b", value: 2)

        list.remove(key: "a")
        list.remove(key: "b")

        XCTAssertNil(list.head)
        XCTAssertTrue(list.keys.isEmpty)
    }

    func testAppendingAfterEmptyingStartsFreshList() {
        let list = DoublyLinkedList<String, Int>()
        list.append(key: "a", value: 1)
        list.remove(key: "a")
        list.append(key: "b", value: 2)

        XCTAssertEqual(list.head?.key, "b")
        XCTAssertEqual(list.keys, ["b"])
        XCTAssertEqual(list.values, [2])
    }

    func testValueMutationIsVisibleThroughList() {
        let list = DoublyLinkedList<String, Int>()
        let node = list.append(key: "a", value: 1)
        node.value = 42
        XCTAssertEqual(list.values, [42])
    }
}
