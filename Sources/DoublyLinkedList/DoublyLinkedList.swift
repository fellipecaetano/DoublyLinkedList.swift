public final class DoublyLinkedList<Key: Equatable, Value> {
    public class Node {
        public let key: Key
        public var value: Value

        var next: Node?
        weak var prev: Node?

        init(key: Key, value: Value) {
            self.key = key
            self.value = value
        }
    }

    public private(set) var head: Node?
    private weak var tail: Node?

    public init() {}

    public var keys: [Key] {
        map { k, _ in k }
    }

    public var values: [Value] {
        map { _, v in v }
    }

    public func map<T>(_ transform: (Key, Value) -> T) -> [T] {
        var cursor = head
        var result = [T]()

        while let current = cursor {
            result.append(transform(current.key, current.value))
            cursor = current.next
        }

        return result
    }

    @discardableResult
    public func append(key: Key, value: Value) -> Node {
        let node = Node(key: key, value: value)
        append(node: node)
        return node
    }

    public func append(node: Node) {
        if let tail {
            tail.next = node
            node.prev = tail
            self.tail = node
        } else {  // empty list
            head = node
            tail = node
        }
    }

    @discardableResult
    public func remove(key: Key) -> Node? {
        var cursor = head

        while let current = cursor {
            if current.key == key {
                remove(node: current)
                return current
            }

            cursor = cursor?.next
        }

        return nil
    }

    public func remove(node: Node) {
        node.next?.prev = node.prev
        node.prev?.next = node.next

        if node === head {
            head = node.next

            if head == nil {
                tail = nil
            }
        }

        if node === tail {
            tail = node.prev
        }
    }
}
