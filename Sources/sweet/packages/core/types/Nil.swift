extension packages.Core {
    class NilType: BaseType<Void>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            eq = {(_ value1: Value, _ value2: Value) -> Bool in true }
            toBit = {(_ value: Value) -> Bit in false }
        }
    }
}
