class BaseMethod: CustomStringConvertible {
    static func == (l: BaseMethod, r: BaseMethod) -> Bool { l.id == r.id }

    struct Options {
        let isConst: Bool
        let isVararg: Bool
        let resultType: ValueType?

        init(isConst: Bool = true, isVararg: Bool = false, resultType: ValueType? = nil) {
            self.isConst = isConst
            self.isVararg = isVararg
            self.resultType = resultType
        }
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
