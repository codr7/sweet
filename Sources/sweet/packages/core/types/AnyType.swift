extension packages.Core {
    class AnyType: BaseType<Any>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
            dump = {(vm, value) in "@"}
            eq = {(value1, value2) in true }
            toBit = {(value) in true }
        }
    }
}

