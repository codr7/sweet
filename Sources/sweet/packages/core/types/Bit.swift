extension packages.Core {
    class BitType: BaseType<Bit>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
            let t = self

            dump = {(vm, value) in value.cast(t) ? "T" : "F"}
            eq = {(value1, value2) in value1.cast(t) == value2.cast(t)}
            toBit = {(value) in value.cast(t)}
        }

        var isRef: Bool = false 
    }
}
