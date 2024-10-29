protocol Method {
    func call(_ vm: VM,
	      _ arguments: [Value],
	      _ result: Register,
	      _ location: Location) throws
}

class BaseMethod: CustomStringConvertible {
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

class SwiftMethod: BaseMethod, Method {
    typealias Body = (_ vm: VM,
                      _ arguments: [Value],
                      _ result: Register,
                      _ location: Location) throws -> Void

    let body: Body

    init(_ id: String, _ arguments: [String], _ options: Options, _ body: @escaping Body) {
        self.body = body
        super.init(id, arguments, options)
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

class SweetMethod: BaseMethod, Method {
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
            vm.currentPackage[id] = Value(packages.Core.registerType, r)
            let v = vm.currentPackage[id]
            if v == nil { throw EmitError("Unknown id: \(id)", location) }
            return Closure(id, r, v!)
        };
    }
    
    func call(_ vm: VM,
	      _ arguments: [Value],
	      _ result: Register,
	      _ location: Location) throws {
        if arguments.count < minArgumentCount {
            throw EvalError("Not enough arguments: \(self)", location)
        }

        vm.beginCall(self, vm.pc+1, result, location)
        
        for i in 0..<min(arguments.count, sweetArguments.count) {
            let a = sweetArguments[i]
            let v = arguments[i]
            vm.registers[a.target] = v
        }

        for c in closure { vm.registers[c.target] = c.value }
        vm.pc = startPc
    }
}
