protocol ValueType {
    typealias Parents = [TypeId:Int]

    var id: String {get}

    typealias Call = (_ vm: VM,
                      _ target: Value,
                      _ arguments: [Value],
                      _ result: Register,
                      _ location: Location) -> Void
    var call: Call? {get}
    
    typealias Dump = (_ vm: VM, _ value: Value) -> String
    var dump: Dump? {get}

    func emit(_ vm: VM, _ target: Value, _ result: Register, _ location: Location) throws

    func emitCall(_ vm: VM,
                  _ target: Value,
                  _ arguments: [Form],
                  _ result: Register,
                  _ location: Location) throws
    
    typealias Eq = (_ value1: Value, _ value2: Value) -> Bool
    var eq: Eq? {get}
    
    func equals(_ other: any ValueType) -> Bool 
    var parents: Parents {get}

    typealias FindId = (_ source: Value, _ id: String) -> Value?
    var findId: FindId? {get}
    
    typealias ToBit = (_ value: Value) -> Bit
    var toBit: ToBit? {get}

    var typeId: TypeId {get}
}

extension ValueType {
     func call(_ vm: VM,
               _ target: Value,
               _ arguments: [Value],
               _ result: Register,
               _ location: Location) {
         vm.setRegister(result, target)
     }

    func equals(_ other: any ValueType) -> Bool { other.id == id }

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
        try arguments.first!.emit(vm, tr)
        let arity = vm.nextRegisters(arguments.count-1)
        let ar = vm.nextRegisters(arguments.count-1)
        for i in 1..<arguments.count { try arguments[i].emit(vm, ar+i) }
        vm.emit(ops.Call.make(vm, tr, ar, arity, result, location))
    }
}

func ==(l: any ValueType, r: any ValueType) -> Bool { l.id == r.id }
func !=(l: any ValueType, r: any ValueType) -> Bool { l.id != r.id }
