struct Location: CustomStringConvertible, Equatable {
    static func == (l: Location, r: Location) -> Bool {
        l.source == r.source && l.line == r.line && l.column == r.column
    }

    let source: String
    var column: Int
    var description: String { "\(source)@\(line):\(column)" }
    var line: Int

    init(_ source: String, line: Int = 1, column: Int = 1) {
        self.source = source
        self.line = line
        self.column = column
    }

    mutating func nextLine() {
        line += 1
        column = 1
    }
}
