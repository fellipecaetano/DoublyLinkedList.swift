import DoublyLinkedList

final class RecentValueCache<Key: Hashable, Value> {
    typealias Node = DoublyLinkedList<Key, Value>.Node

    private let capacity: Int
    private var storage = [Key: Node]()
    private var usageOrdering = DoublyLinkedList<Key, Value>()

    init(capacity: Int) {
        assert(capacity > 0)
        self.capacity = capacity
    }

    func put(_ value: Value, for key: Key) {
        if storage[key] == nil {
            insert(value, for: key)
        } else {
            update(value, for: key)
        }
    }

    private func insert(_ value: Value, for key: Key) {
        if let head = usageOrdering.head, storage.count == capacity {
            storage.removeValue(forKey: head.key)
            usageOrdering.remove(node: head)
        }

        let node = usageOrdering.append(key: key, value: value)
        storage[key] = node
    }

    private func update(_ value: Value, for key: Key) {
        guard let node = storage[key] else {
            return
        }

        usageOrdering.remove(node: node)
        usageOrdering.append(node: node)

        node.value = value
    }

    func value(for key: Key) -> Value? {
        guard let node = storage[key] else {
            return nil
        }

        usageOrdering.remove(node: node)
        usageOrdering.append(node: node)

        return node.value
    }
}
