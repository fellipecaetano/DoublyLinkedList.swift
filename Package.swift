// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "DoublyLinkedList",
    products: [
        .library(name: "DoublyLinkedList", targets: ["DoublyLinkedList"])
    ],
    targets: [
        .target(name: "DoublyLinkedList"),
        .testTarget(
            name: "DoublyLinkedListTests",
            dependencies: ["DoublyLinkedList"]
        ),
        .target(
            name: "RecentValueCacheExample",
            dependencies: ["DoublyLinkedList"],
            path: "Sources/Examples/RecentValueCache"
        ),
        .testTarget(
            name: "RecentValueCacheExampleTests",
            dependencies: ["RecentValueCacheExample"]
        ),
    ]
)
