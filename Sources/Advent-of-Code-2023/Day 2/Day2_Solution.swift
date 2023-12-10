func solveCubeConundrumPart1() -> Int {
    let input = readInput(.cubeConundrum)
    var sum = 0
    for game in input {
        let bag = parseCubeConundrum(String(game))
        if possibleGame(bag: bag) {
            sum += bag.id
        }
    }
    return sum
}

func solveCubeConundrumPart2() -> Int {
    let input = readInput(.cubeConundrum)
    var sum = 0
    for game in input {
        let bag = parseCubeConundrum(String(game))
        let multiplier = findMultiplierOfMinCubesToPlayGame(bag: bag)
        sum += multiplier
    }
    return sum
}

private func possibleGame(bag: ConundrumBag) -> Bool {
    let maxRed = 12
    let maxGreen = 13
    let maxBlue = 14

    return bag.maxRed <= maxRed && bag.maxGreen <= maxGreen && bag.maxBlue <= maxBlue
}

private func findMultiplierOfMinCubesToPlayGame(bag: ConundrumBag) -> Int {
    return bag.maxRed * bag.maxGreen * bag.maxBlue
}
