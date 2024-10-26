struct Location: CustomStringConvertible {
    let source: String

    var column: Int
    var description: String { "\(source)@\(line):\(column)" }
    var line: Int

    init(_ source: String, line: Int = 1, column: Int = 1) {
        self.source = source
        self.line = line
        self.column = column
    }
}
