extension packages.Core {
    class ListType: BaseType<List>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
            let t = self
            
            dump = {(vm, value) in value.cast(t).dump(vm)}
            eq = {(value1, value2) in value1.cast(t) == value2.cast(t)}
            setItem = {(target, index, value) in target.cast(t).items[index] = value}
        }
    }
}
