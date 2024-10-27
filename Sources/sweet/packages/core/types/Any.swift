extension packages.Core {
    class AnyType: BaseType<Any>, ValueType {
        init(_ id: String) { super.init(id) }
    }
}
