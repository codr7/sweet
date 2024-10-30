class VM {
    var calls: [Call] = []
    var code: [Op] = []

    let reader = readers.OneOf(
      readers.Whitespace.instance,
      readers.IntReader.instance,
      readers.Call.instance,
      readers.Id.instance,
      readers.List.instance
    )
    
    var pc: PC = 0
    var registers: [Value] = []
    var tags: [Any] = []

    let core = packages.Core("core")
    var user = Package("user")
    var currentPackage: Package
    
    init() {
        currentPackage = user
        core.initBindings(self)
        user.initBindings(self)
    }

    func doPackage<T>(_ bodyPackage: Package?, _ body: () -> T) -> T {
        let pp = currentPackage
        currentPackage = bodyPackage ?? Package(currentPackage.id, currentPackage)
        defer { currentPackage = pp }
        return body()
    }
    
    @discardableResult
    func emit(_ op: Op) -> PC {
        let result = emitPc
        code.append(op)
        return result
    }

    var emitPc: PC { code.count }

    func endCall() -> Call { calls.removeLast() }

    var nextRegister: Register {
        let result = registers.count
        registers.append(packages.Core.NIL)
        return Register(result)
    }

    func nextRegisters(_ n: Int) -> Register {
        let result = nextRegister
        registers += Array(repeating: packages.Core.NIL, count: n)
        return result
    }
    
    func read(_ input: inout Input,
              _ output: inout [Form],
              _ location: inout Location) throws -> Bool {
        try reader.read(self, &input, &output, &location)
    }

    func read(_ input: inout Input, _ location: inout Location) throws -> [Form] {
        var result: [Form] = []
        while try read(&input, &result, &location) {}
        return result
    }

    func setRegister(_ i: Register, _ value: Value) { registers[Int(i)] = value }
    func register(_ i: Register) -> Value { registers[Int(i)] }

    func tag(_ value: Any) -> Tag {
        let result = tags.count
        tags.append(value)
        return result
    }
}
