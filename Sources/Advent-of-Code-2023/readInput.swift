import Foundation

enum InputFile: String {
    case trebuchet
    case cubeConundrum

    var name: String { self.rawValue + ".txt" }
    var day: Int {
        switch self {
        case .trebuchet: return 1
        case .cubeConundrum: return 2
        }
    }
}

func readInput(fileName: InputFile) -> [Substring] {
    let currentDirectoryPath = FileManager.default.currentDirectoryPath
    let url = URL(fileURLWithPath: currentDirectoryPath)
        .appendingPathComponent("Sources")
        .appendingPathComponent("Advent-of-Code-2023")
        .appendingPathComponent("Day \(fileName.day)")
        .appendingPathComponent(fileName.name)
    let data = try! Data(contentsOf: url)
    guard let input = String(data: data, encoding: .utf8) else {
        fatalError("Faulty input")
    }
    return input.split(separator: "\n")
}

