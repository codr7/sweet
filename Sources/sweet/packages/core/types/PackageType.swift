extension packages.Core {
    class PackageType: BaseType<Package>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            let t = self
            
            eq = {(_ value1: Value, _ value2: Value) -> Bool in
                value1.cast(t) == value2.cast(t)
            }
        }
    }
}
