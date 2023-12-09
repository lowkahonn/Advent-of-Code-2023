import Foundation

struct ConundrumBag {
    let id: Int
    var maxRed: Int
    var maxGreen: Int
    var maxBlue: Int
}

private enum Color: String {
    case red
    case green
    case blue
}

func parseCubeConundrum(_ word: String) -> ConundrumBag {
    // Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    let splitBySemiColon = word.split(separator: ":")
    assert(splitBySemiColon.count == 2)

    let gameId = parseId(String(splitBySemiColon[0]))
    return parseBag(id: gameId, bag: String(splitBySemiColon[1]))
}

private func parseId(_ gameId: String) -> Int {
    // "Game 1"
    let idString = gameId.trimmingPrefix("Game ") 
    guard let id = Int(idString) else {
        fatalError("Invalid gameId \(gameId)")
    }
    return id
}

private func parseBag(id: Int, bag: String) -> ConundrumBag {
    // " 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
    var maxRed = 0
    var maxGreen = 0
    var maxBlue = 0

    let hands = bag.split(separator: ";")
    for hand in hands {
        // "3 blue, 4 red"
        for cubes in hand.split(separator: ",") {
            // "3 blue"
            let splitBySpace = cubes.split(separator: " ")
            assert(splitBySpace.count == 2)

            guard let count = Int(String(splitBySpace[0])) else {
                fatalError("Invalid int \(splitBySpace[0])")
            }
            guard let color = Color.init(rawValue: String(splitBySpace[1])) else {
                fatalError("Invalid color \(splitBySpace[1])")
            }

            switch color {
            case .red: maxRed = max(maxRed, count)
            case .green: maxGreen = max(maxGreen, count)
            case .blue: maxBlue = max(maxBlue, count)
            }
            
        }
    }

    return .init(
        id: id,
        maxRed: maxRed,
        maxGreen: maxGreen,
        maxBlue: maxBlue
    )
}
