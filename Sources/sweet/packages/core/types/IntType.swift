extension packages.Core {
    class IntType: BaseType<Int>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
            let t = self

            eq = {(value1, value2) in value1.cast(t) == value2.cast(t)}
            toBit = {(value) in value.cast(t) != 0}
        }

    }
}
