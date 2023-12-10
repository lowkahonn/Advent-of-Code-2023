private let validDigitStrings = Set(Array(0...9).map { String($0) })

func solveGearRatiosPart2() -> Int {
    let matrix = readInput(.gearRatios)
    var sum = 0
    var currentRow = 0
    let lastRow = matrix.count - 1
    while currentRow < matrix.count {
        let row = matrix[currentRow]
        let topRow = currentRow > 0 ? matrix[currentRow - 1] : nil
        let bottomRow = currentRow < lastRow ? matrix[currentRow + 1] : nil

        for gearIndex in findGears(in: row) {
            guard let (first, second) = findNumbersAroundGear(
                gearIndex: gearIndex,
                row: row,
                topRow: topRow,
                bottomRow: bottomRow
            ) else {
                continue 
            }
            sum += first * second
        }
        currentRow += 1
    }
    return sum
}

private func isNumber(_ char: String) -> Bool { validDigitStrings.contains(char) }

private func isGear(_ char: String) -> Bool { char == "*" }

private func findGears(in row: Substring) -> [Int] {
    var gears = [Int]()
    for (i, char) in row.enumerated() {
        if isGear(String(char)) { gears.append(i) }
    }
    return gears
}

private func findNumbersAroundGear(
    gearIndex: Int,
    row: Substring,
    topRow: Substring?,
    bottomRow: Substring?
) -> (first: Int, second: Int)? {
    var numbersFound = [Int]()

    numbersFound.append(contentsOf: findNumbers(in: row, gearIndex: gearIndex))
    if let topRow {
        numbersFound.append(contentsOf: findNumbers(in: topRow, gearIndex: gearIndex))
    }
    if let bottomRow {
        numbersFound.append(contentsOf: findNumbers(in: bottomRow, gearIndex: gearIndex))
    }

    guard numbersFound.count == 2 else { return nil }
    return (numbersFound[0], numbersFound[1])
}

private func findNumbers(in row: Substring, gearIndex: Int) -> [Int] {
    var numbers = [Int]()
    var (fromIndex, toIndex) = findRangeToSearch(in: row, gearIndex: gearIndex)
    var parsingDigit = false
    var currentDigit = ""
    while fromIndex <= toIndex {
        let char = row[fromIndex..<fromIndex+1]
        let isDigit = isNumber(char)
        switch (parsingDigit, isDigit) {
        case (true, true):
            currentDigit += char
        case (true, false):
            guard let number = Int(currentDigit) else { fatalError("Can't parse digit \(currentDigit)") }
            numbers.append(number)
            parsingDigit = false
            currentDigit = ""
        case (false, true):
            parsingDigit = true
            currentDigit += char
        case (false, false):
            break
        }
        fromIndex += 1
    }

    if parsingDigit, !currentDigit.isEmpty {
        guard let number = Int(currentDigit) else { fatalError("Can't parse digit \(currentDigit)") }
        numbers.append(number)
    }
    return numbers
}

private func findRangeToSearch(in row: Substring, gearIndex: Int) -> (from: Int, to: Int) {
    let checkLeft = gearIndex - 1 > 0
    let checkRight = gearIndex + 1 < row.count
    var index = checkLeft ? gearIndex - 1 : gearIndex
    var rightIndex = checkRight ? gearIndex + 1 : gearIndex
    if checkLeft {
        while index > 0, isNumber(row[index..<index+1]) {
            index = max(0, index - 1)
        }
    }
    if checkRight {
        while rightIndex < row.count - 1, isNumber(row[rightIndex..<rightIndex+1]) {
            rightIndex = min(row.count - 1, rightIndex + 1)
        }
    }
    return (index, rightIndex)
}

