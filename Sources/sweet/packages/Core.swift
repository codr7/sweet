extension packages {
    class Core: Package {
        static let nil_type = NilType("Nil", [])

        let NIL = Value(Core.nil_type, ())
        
        init(_ id: String) {
            super.init(id)
        }
    }
}
