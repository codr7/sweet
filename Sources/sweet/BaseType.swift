nonisolated(unsafe) var nextTypeId: TypeId = 0
nonisolated(unsafe) var typeLookup: [TypeId:ValueType] = [:]

class BaseType<T>: CustomStringConvertible {    
    typealias Data = T

    static func == (l: BaseType<T>, r: BaseType<T>) -> Bool { l.id == r.id }   
    static func findId(_ id: TypeId) -> ValueType? { typeLookup[id] }

    var description: String { id }
    let id: String
    var parents: ValueType.Parents = []
    let typeId: TypeId

    var call: ValueType.Call? = {(vm, target, arguments, result, location) in
        vm.registers[result] = target
    }
    
    var dump: ValueType.Dump? = {(vm, value) in "\(value.data)" }
    var eq: ValueType.Eq? = nil
    var eqv: ValueType.Eq?
    var findId: ValueType.FindId? = nil
    var say: ValueType.Say? = {(vm, target) in target.dump(vm)}
    var setItem: ValueType.SetItem? = nil
    var toBit: ValueType.ToBit? = {(value) in true }

    init(_ id: String, _ parents: [any ValueType] = []) {
        self.id = id
        typeId = nextTypeId
        nextTypeId += 1

        eqv = {[self] in eq!($0, $1)}
        
        self.parents.insert(typeId)
        for p in parents { addParent(p) }
    }

    func addParent(_ parent: any ValueType) {
        for pid in parent.parents {
            parents.insert(pid)
            let p = typeLookup[pid]!
            dump = dump ?? p.dump
            eq = eq ?? p.eq
            toBit = toBit ?? p.toBit
        }
    }

    func emit(_ vm: VM, _ target: Value, _ result: Register, _ location: Location) throws {
        vm.emit(ops.SetRegister.make(vm, result, target));
    }

    func emitCall(_ vm: VM,
                  _ target: Value,
                  _ arguments: [Form],
                  _ result: Register,
                  _ location: Location) throws {
        let arity = arguments.count
        let ar = vm.nextRegisters(arity)
        for i in 0..<arity { try arguments[i].emit(vm, ar+i) }
        vm.emit(ops.CallTag.make(vm, target, ar, arity, result, location))
    }

    func getType(_ vm: VM) -> ValueType? { nil }
    func isDerived(from: ValueType) -> Bool { parents.contains(from.typeId) }
}
