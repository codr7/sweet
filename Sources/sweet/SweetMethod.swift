class SweetMethod: BaseMethod, Method {    
    let sweetArguments: [Argument]
    let result: Register
    let registerOffset: Register
    let location: Location
    var closure: [Closure] = []
    let startPc: PC
    
    init(_ vm: VM,
         _ id: String,
         _ arguments: [Argument],
         _ result: Register,
         _ resultType: ValueType?,
         _ location: Location,
         isConst: Bool = true,
         isVararg: Bool = false) {
        self.sweetArguments = arguments
        self.result = result
        self.location = location
        self.startPc = vm.emitPc
        registerOffset = vm.registers.count
        
        super.init(id, arguments.map({$0.id}), resultType,
                   isConst: isConst, isVararg: isVararg)
    }

    func initClosure(_ vm: VM, _ ids: Set<String>) throws {
        for id in ids {
            if let v = vm.currentPackage[id], v.type == packages.Core.bindingType {
                let r = vm.nextRegister
                vm.currentPackage[id] = Value(packages.Core.bindingType, Binding(r))
                closure.append(Closure(id, r, v))
            }
        }
    }
    
    func call(_ vm: VM,
	      _ arguments: [Value],
	      _ result: Register,
	      _ location: Location) throws {
        
        if arguments.count < minArgumentCount {
            throw EvalError("Not enough arguments: \(self)", location)
        }

        print("SWEETMETHOD result: \(result)")
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
    var type: ValueType?

    init(_ id: String, _ target: Register, _ type: ValueType? = nil) {
        self.id = id
        self.target = target
        self.type = type
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
