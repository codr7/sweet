extension packages.Core {
    class SweetMethodType: BaseType<SweetMethod>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
            let t = self

            call = {(vm, target, arguments, result, location) throws in
                try target.cast(t).call(vm, arguments, result, location)
            }
            
            eq = {(value1, value2) in value1.cast(t) === value2.cast(t)}
        }

        override func emitCall(_ vm: VM,
                      _ target: Value,
                      _ arguments: [Form],
                      _ result: Register,
                      _ location: Location) throws {
            let tr = vm.nextRegister
            vm.emit(ops.SetRegister.make(vm, tr, target))
            let m = target.cast(self)            
            let arity = arguments.count
            var ar = -1
            
            if !m.sweetArguments.isEmpty {
                ar = m.sweetArguments[0].target
                for i in 0..<Swift.min(arity, m.sweetArguments.count) { try arguments[i].emit(vm, ar+i) }
            }

            vm.emit(ops.Call.make(vm, tr, ar, arity, result, location))
        }
    }
}

