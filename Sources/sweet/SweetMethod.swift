class SweetMethod: BaseMethod, Method {    
    let sweetArguments: [Argument]
    let result: Register
    let location: Location
    var closure: [Closure] = []
    let startPc: PC
    
    init(_ id: String,
         _ arguments: [Argument],
         _ result: Register,
         _ options: Options,
         _ location: Location) {
        self.sweetArguments = arguments
        self.result = result
        self.location = location
        self.startPc = vm.emitPc+1
        super.init(id, arguments.map({$0.id}), options)

    }

    func initClosure(_ vm: VM, _ ids: Set<String>) throws {
        try closure = ids.map { id in
            let r = vm.nextRegister
            vm.currentPackage[id] = Value(packages.Core.bindingType, Binding(r))
            let v = vm.currentPackage[id]
            if v == nil { throw EmitError("Unknown id: \(id)", location) }
            return Closure(id, r, v!)
        }
    }
    
    func call(_ vm: VM,
	      _ arguments: [Value],
	      _ result: Register,
	      _ location: Location) throws {
        if arguments.count < minArgumentCount {
            throw EvalError("Not enough arguments: \(self)", location)
        }

        vm.calls.append(Call(vm, self, vm.pc + 1, result, location))
        for c in closure { vm.registers[c.target] = c.value }

        for i in 0..<min(arguments.count, sweetArguments.count) {
            let a = sweetArguments[i]
            if !a.id.isNone {vm.registers[a.target] = arguments[i]}
        }

        vm.pc = startPc
    }
}

struct Argument {
    let id: String
    let target: Register
    let value: Value?

    init(_ id: String, _ target: Register, _ value: Value? = nil) {
        self.id = id
        self.target = target
        self.value = value
    }
}

struct Closure {
    let id: String
    let target: Register
    let value: Value

    init(_ id: String, _ target: Register, _ value: Value) {
        self.id = id
        self.target = target
        self.value = value
    }
}
