class Macro: CustomStringConvertible {
    typealias Body = (_ vm: VM,
                      _ arguments: [Form],
                      _ result: Register,
                      _ location: Location) throws(EmitError) -> Void
    
    let arguments: [String]
    var description: String { "(\(id) [\(arguments.joined(separator: " "))])" }
    let body: Body
    let id: String

    init(_ id: String, _ arguments: [String], _ body: @escaping Body) {
        self.id = id
        self.arguments = arguments
        self.body = body
    }

    func emit(_ vm: VM,
              _ arguments: [Form],
              _ result: Register,
              _ location: Location) throws(EmitError){
        try body(vm, arguments, result, location)
    }
}
