protocol Form {
    var location: Location {get}
    func tryCast<T>(_ type: T.Type) -> T?
    func dump(_ vm: VM) -> String
    func emit(_ vm: VM, _ result: Register) throws
    func emitCall(_ vm: VM, _ arguments: Forms, _ result: Register) throws
    func eval(_ vm: VM, _ result: Register) throws
    func getConstViolation(_ vm: VM) -> Form?
    func getIds(_ ids: inout Set<String>)
    func getRegister(_ vm: VM) -> Register?
    func getType(_ vm: VM) -> ValueType?
    func getValue(_ vm: VM) -> Value?
    var isNone: Bool {get}
    var isSeparator: Bool {get}
}

extension Form {
    func emitCall(_ vm: VM, _ arguments: Forms, _ result: Register) throws {
        let tr = vm.nextRegister
        try emit(vm, tr)
        let arity = vm.nextRegisters(arguments.count-1)
        let ar = vm.nextRegisters(arguments.count-1)
        for i in 1..<arguments.count { try arguments[i].emit(vm, ar+i) }
        vm.emit(ops.Call.make(vm, tr, ar, arity, result, location))
    }

    func eval(_ vm: VM, _ result: Register) throws {
        let skipPc = vm.emit(ops.Stop.make())
        let startPc = vm.emitPc
        try emit(vm, result)
        vm.emit(ops.Stop.make())
        vm.code[skipPc] = ops.Goto.make(vm.emitPc)
        try vm.eval(startPc)
    }

    func eval(_ vm: VM) throws -> Value {
        let result = vm.nextRegister
        vm.registers[result] = packages.Core.NONE;
        try eval(vm, result)
        return vm.registers[result]
    }

    func getConstViolation(_ vm: VM) -> Form? { nil }

    func getIds(_ ids: inout Set<String>) {}

    var isNone: Bool { false }
    var isSeparator: Bool { false }
}

class BaseForm {
    let location: Location
    init(_ location: Location) { self.location = location }
    func tryCast<T>(_ type: T.Type) -> T? {self as? T}

    func getRegister(_ vm: VM) -> Register? {
        let id = tryCast(forms.Id.self)
        if id == nil { return nil }
        let v = vm.currentPackage[id!.value]
        if v == nil { return nil }
        if v!.type != packages.Core.bindingType { return nil }
        return v!.cast(packages.Core.bindingType).register
    }

    func getType(_ vm: VM) -> ValueType? { nil }    
    func getValue(_ vm: VM) -> Value? { nil }
}

typealias Forms = [Form]

extension Forms {
    func emit(_ vm: VM, _ result: Register) throws {
        for f in self { try f.emit(vm, result) }
    }

    func getConstViolation(_ vm: VM) -> Form? {
        for f in self {
            if let cv = f.getConstViolation(vm) { return cv }
        }

        return nil
    }

    var ids: Set<String> {
        var result: Set<String> = []
        for f in self { f.getIds(&result) }
        return result
    }
}

final class EmitError: BaseError, @unchecked Sendable {}

struct forms {}

