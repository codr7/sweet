class Macro: CustomStringConvertible {
    typealias Body = (_ vm: VM,
                      _ arguments: [Form],
                      _ result: Register,
                      _ location: Location) throws -> Void
    
    let arguments: [String]
    let minArgumentCount: Int
    var description: String { "(\(id) [\(arguments.joined(separator: " "))])" }
    let body: Body
    let id: String
    let resultType: ValueType?
    
    init(_ id: String, _ arguments: [String], _ resultType: ValueType?, _ body: @escaping Body) {
        self.id = id
        self.arguments = arguments
        self.minArgumentCount = arguments.count(where: {$0.last != "?"})
        self.body = body
        self.resultType = resultType
    }

    var isConst: Bool { id.last! != "!" }
    
    func emit(_ vm: VM,
              _ arguments: [Form],
              _ result: Register,
              _ location: Location) throws {
        try body(vm, arguments, result, location)
    }
}
