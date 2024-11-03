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
         _ resultType: ValueType?,
         isConst: Bool = true,
         isVararg: Bool = false) {
        self.id = id
        self.arguments = arguments
        self.minArgumentCount = arguments.count(where: {$0.last != "?"})
        self.resultType = resultType
        self.isConst = isConst
        self.isVararg = isVararg
    }
}
