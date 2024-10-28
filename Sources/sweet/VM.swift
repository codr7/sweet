class VM {    
    var code: [Op] = []

    let reader = readers.OneOf(
      readers.Whitespace.instance,
      readers.Id.instance
    )
    
    var pc: PC = 0
    var registers: [Value] = []
    var tags: [Value] = []

    let core = packages.Core("core")
    var user = Package("user")
    var currentPackage: Package
    
    init() {
        currentPackage = user
        core.setup(self)
        user.setup(self)
    }

    @discardableResult
    func emit(_ op: Op) -> PC {
        let result = emitPc
        code.append(op)
        return result
    }

    var emitPc: PC { get {PC(code.count)} }

    var nextRegister: Register {
        let result = registers.count
        registers.append(packages.Core.NIL)
        return Register(result)
    }

    func read(_ input: inout Input, _ location: inout Location) -> [Form] {
        var result: [Form] = []
        while reader.read(&input, &result, &location) {}
        return result
    }
    
    func register(_ i: Register, _ value: Value) { registers[Int(i)] = value }
    func register(_ i: Register) -> Value { registers[Int(i)] }

    func tag(_ value: Value) -> Tag {
        let result = tags.count
        tags.append(value)
        return Tag(result)
    }

    func tag(_ i: Tag) -> Value { tags[Int(i)] }
}
