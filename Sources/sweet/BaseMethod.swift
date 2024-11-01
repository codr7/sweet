class BaseMethod: CustomStringConvertible {
    static func == (l: BaseMethod, r: BaseMethod) -> Bool { l.id == r.id }

    let id: String
    let arguments: [String]
    let minArgumentCount: Int
    var description: String { "(\(id) [\(arguments.joined(separator: " "))])" }
    var isConst: Bool
    var isVararg: Bool
    var resultType: ValueType?

    init(_ id: String,
         _ arguments: [String],
         isConst: Bool = true,
         isVararg: Bool = false,
         resultType: ValueType? = nil) {
        self.id = id
        self.arguments = arguments
        self.minArgumentCount = arguments.count(where: {$0.last != "?"})
        self.isConst = isConst
        self.isVararg = isVararg
        self.resultType = resultType
    }
}
