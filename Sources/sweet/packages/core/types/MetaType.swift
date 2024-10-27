extension packages.Core {
    class MetaType: BaseType<ValueType>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            let t = self
            eq = {(value1, value2) -> Bool in value1.cast(t).id == value2.cast(t).id}
        }
    }
}
