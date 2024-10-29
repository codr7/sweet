protocol Method {
    var id: String {get}
    
    func call(_ vm: VM,
	      _ arguments: [Value],
	      _ result: Register,
	      _ location: Location) throws
}

class BaseMethod: CustomStringConvertible {
    static func == (l: BaseMethod, r: BaseMethod) -> Bool { l.id == r.id }

    struct Options {
        let isConst = true
        let isVararg = false
        let resultType: ValueType? = nil
    }
        
    let id: String
    let arguments: [String]
    let minArgumentCount: Int
    var description: String { "(\(id) [\(arguments.joined(separator: " "))])" }
    let options: Options

    init(_ id: String, _ arguments: [String], _ options: Options) {
        self.id = id
        self.arguments = arguments
        self.minArgumentCount = arguments.count(where: {$0.last != "?"})
        self.options = options
    }
}
