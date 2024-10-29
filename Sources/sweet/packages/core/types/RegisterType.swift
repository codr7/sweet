extension packages.Core {
    class RegisterType: BaseType<Register>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
            let t = self
            eq = {(value1, value2) -> Bool in value1.cast(t) == value2.cast(t)}
        }
    }
}
