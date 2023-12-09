import Foundation

private let validDigitStrings = Set([1, 2, 3, 4, 5, 6, 7, 8, 9].map { String($0) })

func solveTrebuchetPart1(input: [Substring] = trebuchetInput) -> Int {
    var sum = 0

    for word in input { 
        let (leftDigitString, leftIndex) = lookForNum(
            direction: .forward, 
            word: String(word), 
            bound: nil
        )

        let (rightDigitString, _) = lookForNum(
            direction: .backward, 
            word: String(word), 
            bound: leftIndex // we can overlap
        )
        let num = Int(leftDigitString + rightDigitString) ?? 0
        sum += num
    }

    return sum
}

private func lookForNum(
    direction: Direction, 
    word: String, 
    bound: Int?
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
    
    while shouldContinue() {
        let char = word[index..<index+1]
        if validDigitStrings.contains(char) {
            return (digitString: char, index: index)
        }

        index += direction.increment
    }

    return (digitString: "", index: index)
}
