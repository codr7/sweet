class SwiftMethod: BaseMethod, Method {
    typealias Body = (_ vm: VM,
                      _ arguments: [Value],
                      _ result: Register,
                      _ location: Location) throws -> Void

    let body: Body

    init(_ id: String,
         _ arguments: [String],
         _ body: @escaping Body,
         isConst: Bool = true,
         isVararg: Bool = false,
         resultType: ValueType? = nil) {
        self.body = body
        
        super.init(id,
                   arguments,
                   isConst: isConst,
                   isVararg: isVararg,
                   resultType: resultType)
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
