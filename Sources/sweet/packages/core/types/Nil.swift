extension packages.Core {
    class NilType: BaseType<Void>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) { super.init(id, parents) }
        func equals(_ value1: Value, _ value2: Value) -> Bool { true }
        func toBit(_ value: Value) -> Bit { false }
    }
}
