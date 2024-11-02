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
            var p: Pair? = t.tryCast(Pair.self)

            while p != nil {
                if p!.left.isNone { t = p!.left }
                else if p!.right.isNone { t = p!.right }
                else { break }
                p = t.tryCast(Pair.self)
            }

            try t.emitCall(vm, Array(arguments[1...]), result)
            t = arguments.first!
            p = t.tryCast(Pair.self)

            while p != nil {
                if p!.left.isNone {
                    vm.emit(ops.Unzip.make(result, nil, result))
                    t = p!.right
                } else if p!.right.isNone {
                    vm.emit(ops.Unzip.make(result, result, nil))
                    t = p!.left
                } else { break }
                
                p = t.tryCast(Pair.self)
            }
        }

        func getConstViolation(_ vm: VM) -> Form? {
            if let v = arguments.first!.getValue(vm) {
                if let m = v.tryCast(packages.Core.macroType), !m.isConst { return self }
                if let m = v.tryCast(packages.Core.methodType), !m.isConst { return self }
            }

            for a in arguments {
                if let cv = a.getConstViolation(vm) { return cv }
            }
            
            return nil
        }

        func getIds(_ ids: inout Set<String>) {
            for f in arguments { f.getIds(&ids) }
        }

        override func getType(_ vm: VM) -> ValueType? {
            if let m = arguments.first!.getValue(vm)?.cast(packages.Core.methodType) {
                return m.resultType
            }

            return nil
        }
    }
}
