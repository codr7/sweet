extension packages.Core {
    class PairType: BaseType<Pair>, CountTrait, ValueType {
        var count: CountTrait.Count?

        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
            let t = self
            
            count = {(target) in
                var p = target
                var n = 1

                while p.type == t {
                    p = p.cast(t).1
                    n += 1
                }

                return n
            }
            
            dump = {(vm, value) in sweet.dump(vm, value.cast(t))}
            eq = {(value1, value2) in value1.cast(t) == value2.cast(t)}
        }
    }
}
