extension packages.Core {
    class TimeType: BaseType<Duration>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
            let t = self

            eq = {(value1, value2) in value1.cast(t) == value2.cast(t)}
            toBit = {(value) in value.cast(t) != Duration.milliseconds(0) }
        }

        var isRef: Bool = false 
    }
}
