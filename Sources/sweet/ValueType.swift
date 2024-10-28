protocol ValueType {    
    var id: String {get}
    typealias Dump = (_ vm: VM, _ value: Value) -> String
    var dump: Dump? {get}

    func emit(_ vm: VM, _ target: Value, _ result: Register)
    
    typealias Eq = (_ value1: Value, _ value2: Value) -> Bool
    var eq: Eq? {get}
    
    func equals(_ other: any ValueType) -> Bool 
    var parents: [ValueType] {get}

    typealias FindId = (_ source: Value, _ id: String) -> Value?
    var findId: FindId? {get}
    
    typealias ToBit = (_ value: Value) -> Bit
    var toBit: ToBit? {get}

    var typeId: TypeId {get}
}

extension ValueType {
    func equals(_ other: any ValueType) -> Bool { other.id == id }

    func emit(_ vm: VM, _ target: Value, _ result: Register) {
        vm.emit(ops.SetRegister.make(vm, result, target));
    }
}

func ==(l: any ValueType, r: any ValueType) -> Bool { l.id == r.id }
func !=(l: any ValueType, r: any ValueType) -> Bool { l.id != r.id }
