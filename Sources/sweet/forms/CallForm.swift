extension forms {
    class Call: BaseForm, Form {
        let arguments: [Form]
        
        init(_ arguments: [Form], _ location: Location) {
            self.arguments = arguments
            super.init(location)
        }

        func dump(_ vm: VM) -> String {
            "(\(arguments.map({"\($0.dump(vm))"}).joined(separator: " ")))"
        }
        
        func emit(_ vm: VM, _ result: Register) throws {
            var t = arguments.first!
            var p: Pair? = t.cast(Pair.self)

            while p != nil {
                if p!.left.isNone { t = p!.left }
                else if p!.right.isNone { t = p!.right }
                else { break }
                p = t.cast(Pair.self)
            }

            try t.emitCall(vm, Array(arguments[1...]), result)
            t = arguments.first!
            p = t.cast(Pair.self)

            while p != nil {
                if p!.left.isNone {
                    vm.emit(ops.Unzip.make(result, nil, result))
                    t = p!.right
                } else if p!.right.isNone {
                    vm.emit(ops.Unzip.make(result, result, nil))
                    t = p!.left
                } else { break }
                
                p = t.cast(Pair.self)
            }
        }

        func getConstViolation(_ vm: VM) -> Form? {
            if let v = arguments.first!.getValue(vm) {
                if v.type == packages.Core.macroType &&
                     !v.cast(packages.Core.macroType).isConst { return self }
                
                if v.type == packages.Core.methodType &&
                     v.cast(packages.Core.methodType).options.isConst { return self }
            }

            for a in arguments {
                if let cv = a.getConstViolation(vm) { return cv }
            }
            
            return nil
        }        
    }
}
