extension packages {
    class Core: Package {
        static let nilType = NilType("Nil", [])
        static let anyType = AnyType("Any")
        static let metaType = MetaType("Meta", [anyType])

        static let packageType = PackageType("Package", [anyType])
        
        let NIL = Value(Core.nilType, ())
        
        override func setup(_ vm: VM) {
            bind(Core.anyType)
            bind(Core.metaType)
            bind(Core.nilType)
            bind(Core.packageType)
        }
    }
}
