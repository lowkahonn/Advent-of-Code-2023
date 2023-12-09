import Foundation

private let stringToDigitString: [String: String] = [
    "one": "1",
    "two": "2",
    "three": "3",
    "four": "4",
    "five": "5",
    "six": "6",
    "seven": "7",
    "eight": "8",
    "nine": "9",
    "1": "1",
    "2": "2",
    "3": "3",
    "4": "4",
    "5": "5",
    "6": "6",
    "7": "7",
    "8": "8",
    "9": "9",
]

private struct LookupTrie {
    let forwardTrie: Trie
    let backwardTrie: Trie
}

func solveTrebuchetPart2(input: [Substring] = trebuchetInput) -> Int {
    let forwardTrie = Trie()
    let backwardTrie = Trie()

    for digitString in stringToDigitString.keys {
        forwardTrie.insert(content: digitString)
        backwardTrie.insert(content: String(digitString.reversed()))
    }

    let trie = LookupTrie(forwardTrie: forwardTrie, backwardTrie: backwardTrie)
    var sum = 0
    for word in input {
        let (leftDigitString, leftIndex) = lookForNum(
            direction: .forward, 
            word: String(word), 
            bound: nil, 
            trie: trie.forwardTrie
        )

        let (rightDigitString, _) = lookForNum(
            direction: .backward, 
            word: String(word), 
            bound: leftIndex, // we can overlap
            trie: trie.backwardTrie
        )

        let num = Int(leftDigitString + rightDigitString) ?? 0
        sum += num
    }
    return sum
}

private func lookForNum(
    direction: Direction, 
    word: String, 
    bound: Int?,
    trie: Trie
) -> (digitString: String, index: Int) {
    var index: Int
    let limit: Int
    switch direction {
    case .forward: 
        index = 0
        limit = bound ?? word.count - 1
    case .backward: 
        index = word.count - 1
        limit = bound ?? 0
    }

    let shouldContinue = { () -> Bool in 
        switch direction {
        case .forward: return index <= limit
        case .backward: return limit <= index
        }
    }
    
    var node: TrieNode?
    var stack = [(node: TrieNode, index: Int)]()

    while shouldContinue() {
        let char = word[index..<index+1]
        if node != nil, let backtrackNode = trie.startingNode(char) {
            // if we have a walking node and we found a starting node
            // we insert at the beginning and popLast()
            stack.insert((node: backtrackNode, index: index), at: 0)
        }

        node = trie.walk(node: node, nextValue: char)

        if node == nil, let (backtrackNode, backtrackIndex) = stack.popLast() {
            node = backtrackNode
            index = backtrackIndex
        }

        if let value = node?.terminatingValue, 
            let digitString = stringToDigitString[value] ?? stringToDigitString[String(value.reversed())] {
            return (digitString: digitString, index: index)
        }

        index += direction.increment
    }

    return (digitString: "", index: index)
}
