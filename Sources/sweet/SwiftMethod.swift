class SwiftMethod: BaseMethod, Method {
    typealias Body = (_ vm: VM,
                      _ arguments: [Value],
                      _ result: Register,
                      _ location: Location) throws -> Void

    let body: Body

    init(_ id: String,
         _ arguments: [String],
         _ resultType: ValueType?,
         _ body: @escaping Body,
         isConst: Bool = true,
         isVararg: Bool = false) {
        self.body = body
        
        super.init(id,
                   arguments,
                   resultType,
                   isConst: isConst,
                   isVararg: isVararg)
    }

    func call(_ vm: VM,
	      _ arguments: [Value],
	      _ result: Register,
	      _ location: Location) throws {
        if arguments.count < minArgumentCount {
            throw EvalError("Not enough arguments: \(self)", location)
        }
        vm.pc += 1
        try body(vm, arguments, result, location)
    }
}
