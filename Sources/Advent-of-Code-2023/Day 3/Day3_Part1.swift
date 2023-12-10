private let validDigitStrings = Set(Array(0...9).map { String($0) })

func solveGearRatiosPart1() -> Int {
    let matrix = readInput(.gearRatios)
    var sum = 0
    var currentRow = 0
    let lastRow = matrix.count - 1
    while currentRow < matrix.count {
        let topRow = currentRow > 0 ? matrix[currentRow - 1] : nil
        let bottomRow = currentRow < lastRow ? matrix[currentRow + 1] : nil
        let numbers = findNumbersInRow(
            matrix[currentRow],
            topRow: topRow,
            bottomRow: bottomRow
        )
        sum += numbers.reduce(into: 0) { $0 += $1 }
        currentRow += 1
    }
    return sum
}

private func findNumbersInRow(
    _ row: Substring,
    topRow: Substring?,
    bottomRow: Substring?
) -> [Int] {
    var currentIndex = 0
    var validNumbers = [Int]()
    while currentIndex < row.count {
        let (number, fromIndex, toIndex) = findFirstNumber(in: row, from: currentIndex)
        if let number, isValidNumber(from: fromIndex, to: toIndex, row: row, topRow: topRow, bottomRow: bottomRow) {
            validNumbers.append(number)
        }
        currentIndex = toIndex + 1
    }
    return validNumbers
}

private func findFirstNumber(in row: Substring, from index: Int) -> (number: Int?, fromIndex: Int, toIndex: Int) {
    var index = index
    var fromIndex = 0
    var digit = ""
    var parsingDigit = false
    var continueSearching = true
    while index < row.count, continueSearching {
        let char = row[index..<index+1]
        let isDigit = validDigitStrings.contains(char)

        switch (parsingDigit, isDigit) {
        case (true, true):
            digit += char
            index += 1
        case (false, true):
            parsingDigit = true
            digit += char
            fromIndex = index
            index += 1
        case (true, false):
            parsingDigit = false
            continueSearching = false
        case (false, false):
            index += 1
        }
    }
    return (Int(digit), fromIndex, index)
}

private func isValidNumber(from: Int, to: Int, row: Substring, topRow: Substring?, bottomRow: Substring?) -> Bool {
    let foundInRow = hasSymbolInRow(from: from, to: to, checkInBetween: false, row: row)
    var foundInTopRow = false
    if let topRow {
        foundInTopRow = hasSymbolInRow(from: from, to: to, checkInBetween: true, row: topRow)
    }
    var foundInBottomRow = false
    if let bottomRow {
        foundInBottomRow = hasSymbolInRow(from: from, to: to, checkInBetween: true, row: bottomRow)
    }
    return foundInRow || foundInTopRow || foundInBottomRow
}

private func hasSymbolInRow(from: Int, to: Int, checkInBetween: Bool, row: Substring) -> Bool {
    let checkLeft = from - 1 > 0
    let checkRight = to + 1 < row.count
    var startIndex = checkLeft ? from - 1 : from
    let toIndex = checkRight ? to + 1 : to
    let leftIsSymbol = isSymbol(row[startIndex..<startIndex+1])
    let rightIsSymbol = isSymbol(row[toIndex-1..<toIndex])
    if leftIsSymbol || rightIsSymbol { return true }

    guard checkInBetween else { return false }
    while startIndex < toIndex {
        let char = row[startIndex..<startIndex+1]
        startIndex += 1
        if isSymbol(char) { return true }
    }
    return false
}

private func isSymbol(_ char: String) -> Bool {
    return char != "." && !validDigitStrings.contains(char)
}
