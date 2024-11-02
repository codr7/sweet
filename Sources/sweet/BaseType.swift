var nextTypeId: TypeId = 0
var typeLookup: [TypeId:ValueType] = [:]

class BaseType<T> {    
    typealias Data = T

    static func == (l: BaseType<T>, r: BaseType<T>) -> Bool { l.id == r.id }   
    static func findId(_ id: TypeId) -> ValueType? { typeLookup[id] }

    let id: String
    var parents: ValueType.Parents = [:]
    let typeId: TypeId

    var call: ValueType.Call? = {(vm, target, arguments, result, location) in
        vm.registers[result] = target
    }
    
    var dump: ValueType.Dump? = {(vm, value) in "\(value.data)" }
    var eq: ValueType.Eq? = nil
    var eqv: ValueType.Eq?
    var findId: ValueType.FindId? = nil
    var setItem: ValueType.SetItem? = nil
    var toBit: ValueType.ToBit? = {(value) in true }

    init(_ id: String, _ parents: [any ValueType] = []) {
        self.id = id
        typeId = nextTypeId
        nextTypeId += 1

        eqv = {[self] in eq!($0, $1)}
        
        self.parents[typeId] = 1
        for p in parents { addParent(p) }
    }

    func addParent(_ parent: any ValueType) {
        for (pid, w) in parent.parents {
            let ew = parents[pid]
            if ew != nil { parents[pid] = ew! + w }
            else { parents[pid] = w }
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
        let tr = vm.nextRegister
        vm.emit(ops.SetRegister.make(vm, tr, target))
        let arity = arguments.count
        let ar = vm.nextRegisters(arity)
        for i in 0..<arity { try arguments[i].emit(vm, ar+i) }
        vm.emit(ops.Call.make(vm, tr, ar, arity, result, location))
    }
}
