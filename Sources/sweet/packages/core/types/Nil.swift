extension packages.Core {
    class NilType: BaseType<Void>, ValueType {
        var eq: Eq? = {(_ value1: Value, _ value2: Value) -> Bool in true }
        var toBit: ToBit? = {(_ value: Value) -> Bit in false }
    }
}
