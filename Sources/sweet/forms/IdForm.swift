extension String {
    var isNil: Bool { self == "_" } 
}

extension forms {
    class Id: BaseForm, Form {
        static func find(_ vm: VM, _ source: Package, _ id: String) -> Value? {
            var s = Value(packages.Core.packageType, source)
            var sid = id
            
            while true {
                let i = id.firstIndex(of: "/")
                if i == nil {break}
                let lid = String(sid[..<i!])
                let lv = s.findId(lid)
                if lv == nil {return nil}
                s = lv!
                sid = String(sid[sid.index(after: i!)...])
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
        
        override func getValue(_ vm: VM) -> Value? { Id.find(vm, vm.currentPackage, value) }

        var isNil: Bool { value.isNil }
    }
}
