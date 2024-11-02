extension forms {
    class Id: BaseForm, Form {
        static func find(_ vm: VM, _ source: Package, _ id: String) -> Value? {
            var s = Value(packages.Core.packageType, source)
            var sid = id
            
            while let i = sid.firstIndex(of: "/") {
                if let lv = s.findId(String(sid[..<i])) {
                    s = lv
                    sid = String(sid[sid.index(after: i)...])
                } else {
                    break
                }
            }

            return s.findId(sid)
        }
        
        let value: String
        
        init(_ value: String, _ location: Location) {
            self.value = value
            super.init(location)
        }

        func dump(_ vm: VM) -> String { value }
        
        func emit(_ vm: VM, _ result: Register) throws {
            let v = Id.find(vm, vm.currentPackage, value);
            if v == nil { throw EmitError("Unknown id: \(value)", location) }
            try v!.emit(vm, result, location)
        }

        func emitCall(_ vm: VM, _ arguments: [Form], _ result: Register) throws {
            let v = Id.find(vm, vm.currentPackage, value);
            if v == nil { throw EmitError("Unknown id: \(value)", location) }
            try v!.emitCall(vm, arguments, result, location)            
        }

        override func getType(_ vm: VM) -> ValueType? {
            if let v = getValue(vm) { v.type } else { nil }
        }

        func getIds(_ ids: inout Set<String>) { ids.insert(value) }

        override func getValue(_ vm: VM) -> Value? { Id.find(vm, vm.currentPackage, value) }

        var isNone: Bool { value.isNone }
        var isSeparator: Bool { value.isSeparator }
    }
}
