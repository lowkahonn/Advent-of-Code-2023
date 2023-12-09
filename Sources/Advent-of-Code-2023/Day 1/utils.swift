extension String {
    subscript(range: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start..<end])
    }
}

extension Substring {
    subscript(range: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start..<end])
    }
}

class TrieNode {
    var value: String?
    var children: [String: TrieNode] = [:]
    var terminatingValue: String?
    init(value: String? = nil) {
        self.value = value
    }

    func add(key: String) -> TrieNode {
        if let child = children[key] {
            return child
        }

        let node = TrieNode(value: key)
        children[key] = node
        return node
    }
}

struct Trie {
    fileprivate let root: TrieNode
    init() {
        root = TrieNode()
    }

    func insert(content: String) {
        var currentNode = root
        for (i, key) in content.enumerated() {
            currentNode = currentNode.add(key: String(key))
            if i == content.count - 1 {
                currentNode.terminatingValue = content
            }
        }
    }

    func startingNode(_ letter: String) -> TrieNode? {
        return root.children[letter]
    }

    func walk(node: TrieNode? = nil, nextValue: String) -> TrieNode? {
        let node = node ?? root
        return node.children[nextValue]
    }

    func printTrie() {
        printTrieHelper(node: root, indent: 1)
        
        func printTrieHelper(node: TrieNode, indent: Int) {
            let leadingIndent = "| "
            let lastIndent = "|-"
            let terminatingSign = " ->"
            for (k, v) in node.children {
                let indentation = String(repeating: leadingIndent, count: indent - 1) 
                print(indentation + lastIndent + k, terminator: "")
                if let terminatingValue = v.terminatingValue {
                    print(terminatingSign, terminator: " ")
                    print(terminatingValue, terminator: "")
                }
                print("", terminator: "\n")
                printTrieHelper(node: v, indent: indent + 1)
            }
        }
    }
}

enum Direction {
    case forward
    case backward

    var increment: Int {
        switch self {
        case .forward: return 1
        case .backward: return -1
        }
    }
}
