protocol Form {
    var location: Location {get}
    func cast<T>(_ type: T.Type) -> T?
    func dump(_ vm: VM) -> String
    func emit(_ vm: VM, _ result: Register) throws
    func emitCall(_ vm: VM, _ arguments: [Form], _ result: Register) throws
    func eval(_ vm: VM, _ result: Register) throws
    func getRegister(_ vm: VM) -> Register?
    func getValue(_ vm: VM) -> Value?
    var isNil: Bool {get}
}

extension Form {
    func emitCall(_ vm: VM, _ arguments: [Form], _ result: Register) throws {
        let tr = vm.nextRegister
        try arguments.first!.emit(vm, tr)
        let arity = vm.nextRegisters(arguments.count-1)
        let ar = vm.nextRegisters(arguments.count-1)
        for i in 1..<arguments.count { try arguments[i].emit(vm, ar+i) }
        vm.emit(ops.Call.make(vm, tr, ar, arity, result, location))
    }

    func eval(_ vm: VM, _ result: Register) throws {
        let skipPc = vm.emit(ops.Stop.make())
        let startPc = vm.pc
        try emit(vm, result)
        vm.emit(ops.Stop.make())
        vm.code[skipPc] = ops.Goto.make(startPc)
        try vm.eval(startPc)
    }

    var isNil: Bool { false }
}

class BaseForm {
    let location: Location
    init(_ location: Location) { self.location = location }
    func cast<T>(_ type: T.Type) -> T? {self as? T}

    func getRegister(_ vm: VM) -> Register? {
        let id = cast(forms.Id.self)
        if id == nil { return nil }
        let v = vm.currentPackage[id!.value]
        if v == nil { return nil }
        if v!.type != packages.Core.registerType { return nil }
        return v!.cast(packages.Core.registerType)
    }
    
    func getValue(_ vm: VM) -> Value? { nil }
}

extension [Form] {
    func emit(_ vm: VM, _ result: Register) throws {
        for f in self { try f.emit(vm, result) }
    }
}

class EmitError: BaseError {}

struct forms {}
