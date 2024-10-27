extension packages.Core {
    class PackageType: BaseType<Package>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            let t = self
            eq = {(value1, value2) in value1.cast(t) == value2.cast(t)}
        }
    }
}
