protocol ValueType {    
    var id: String {get}
    func dump(_ vm: VM, _ value: Value) -> String
    func equals(_ other: any ValueType) -> Bool 
    func equals(_ value1: Value, _ value2: Value) -> Bool
    var hierarchy: Set<TypeId> {get}
    func toBit(_ value: Value) -> Bit
}

extension ValueType {
    static func == (l: any ValueType, r: any ValueType) -> Bool {
        l.id == r.id
    }

    func dump(_ vm: VM, _ value: Value) -> String {
        "\(value.data)"        
    }

    func equals(_ other: any ValueType) -> Bool {
        return other.id == id
    }
}
