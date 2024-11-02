protocol ValueType {
    typealias Parents = [TypeId:Int]

    var id: String {get}

    typealias Call = (_ vm: VM,
                      _ target: Value,
                      _ arguments: [Value],
                      _ result: Register,
                      _ location: Location) throws -> Void
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
    
    typealias Eqv = (_ value1: Value, _ value2: Value) -> Bool
    var eqv: Eqv? {get}

    func equals(_ other: any ValueType) -> Bool 
    var parents: Parents {get}

    typealias FindId = (_ source: Value, _ id: String) -> Value?
    var findId: FindId? {get}

    typealias Say = (_ vm: VM, _ target: Value) -> String
    var say: Say? {get}
    
    typealias SetItem = (_ target: Value, _ index: Int, _ value: Value) -> Void
    var setItem: SetItem? {get}

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
         vm.registers[result] = target
     }

    func equals(_ other: any ValueType) -> Bool { other.id == id }
}

func ==(l: any ValueType, r: any ValueType) -> Bool { l.id == r.id }
func !=(l: any ValueType, r: any ValueType) -> Bool { l.id != r.id }
