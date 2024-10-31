extension packages.Core {
    class MacroType: BaseType<Macro>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
            let t = self
            eq = {(value1, value2) in value1.cast(t).id == value2.cast(t).id}
        }

        override func emitCall(_ vm: VM,
                      _ target: Value,
                      _ arguments: [Form],
                      _ result: Register,
                      _ location: Location) throws {
            try target.cast(self).emit(vm, arguments, result, location)
        }
    }
}
