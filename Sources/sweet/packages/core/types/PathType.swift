extension packages.Core {
    class PathType: BaseType<Path>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
            let t = self
            
            dump = {(vm, value) in "$\(value.cast(t))"}
            eq = {(value1, value2) in value1.cast(t) == value2.cast(t)}
            toBit = {(value) in !value.cast(t).isEmpty}
        }

        var isRef: Bool = false
    }
}
