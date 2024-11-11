extension packages.Core {
    class MethodType: BaseType<Method>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
            let t = self

            call = {(vm, target, arguments, result, location) throws in
                try target.cast(t).call(vm, arguments, result, location)
            }
            
            eq = {(value1, value2) in value1.cast(t).id == value2.cast(t).id}
        }
    }
}
