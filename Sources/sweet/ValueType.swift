protocol ValueType {    
    var id: String {get}
    typealias Dump = (_ vm: VM, _ value: Value) -> String
    var dump: Dump? {get}

    typealias Eq = (_ value1: Value, _ value2: Value) -> Bool
    var eq: Eq? {get}
    
    func equals(_ other: any ValueType) -> Bool 
    var parents: [ValueType] {get}
    
    typealias ToBit = (_ value: Value) -> Bit;
    var toBit: ToBit? {get}

    var typeId: TypeId {get}
}

extension ValueType {
    static func == (l: any ValueType, r: any ValueType) -> Bool { l.id == r.id }
    func equals(_ other: any ValueType) -> Bool { other.id == id }
}
