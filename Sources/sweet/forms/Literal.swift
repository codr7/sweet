extension forms {
    class Literal: BaseForm, Form {
        let value: Value
        
        init(_ value: Value, _ location: Location) {
            self.value = value
            super.init(location)
        }

        func dump(_ vm: VM) -> String { value.dump(vm) }

        func emit(_ vm: VM, _ result: Register) throws {
            try value.emit(vm, result, location);
        }

        override func getType(_ vm: VM) -> ValueType? {
            (value.type == packages.Core.metaType)
              ? value.cast(packages.Core.metaType)
              : nil
        }

        override func getValue(_ vm: VM) -> Value? { value }
        var isNone: Bool { value == packages.Core.NONE }
    }
}
