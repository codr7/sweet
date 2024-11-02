extension packages.Core {
    class BindingType: BaseType<Binding>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
            let t = self
            eq = {(value1, value2) -> Bool in value1.cast(t) == value2.cast(t)}
        }

        override func emit(_ vm: VM,
                           _ target: Value,
                           _ result: Register,
                           _ location: Location) throws {
            let r = target.cast(self).register
            if (r != result) { vm.emit(ops.Copy.make(r, result)) }
        }

        var isRef: Bool = true 
    }
}
