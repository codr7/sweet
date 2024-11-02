extension packages.Core {
    class StringType: BaseType<String>, CountTrait, ValueType {
        var count: CountTrait.Count?

        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
            let t = self
            
            count = {(target) in target.cast(t).count}
            dump = {(vm, value) in "\"\(value.cast(t))\""}
            eq = {(value1, value2) in value1.cast(t) == value2.cast(t)}
            say = {(vm, value) in value.cast(t)}
            //setItem = {(target, index, value) in target.cast(t)[index] = value}
            toBit = {(value) in !value.cast(t).isEmpty}
        }
    }
}
