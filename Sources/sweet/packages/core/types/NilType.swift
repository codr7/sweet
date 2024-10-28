extension packages.Core {
    class NilType: BaseType<Void>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            dump = {(vm, value) in "_"}
            eq = {(value1, value2) in true }
            toBit = {(value) in false }
        }
    }
}
