extension packages {
    class Core: Package {
        static let nilType = NilType("Nil", [])
        static let anyType = AnyType("Any")

        static let bitType = BitType("Bit", [anyType])
        static let macroType = MacroType("Macro", [anyType])
        static let metaType = MetaType("Meta", [anyType])
        static let packageType = PackageType("Package", [anyType])
        static let pairType = PairType("Pair", [anyType])
        static let registerType = RegisterType("Register", [anyType])
        
        static let NIL = Value(Core.nilType, ())
        
        static let T = Value(Core.bitType, true)
        static let F = Value(Core.bitType, false)
        
        override func setup(_ vm: VM) {
            bind(Core.anyType)
            bind(Core.bitType)
            bind(Core.macroType)
            bind(Core.metaType)
            bind(Core.nilType)
            bind(Core.packageType)
            bind(Core.pairType)
            bind(Core.registerType)

            self["_"] = Core.NIL
            self["T"] = Core.T
            self["F"] = Core.F

            bindMacro("import!", ["source", "id1?"],
                      {(vm, arguments, result, location) in
                          vm.registers[result] = Core.NIL
                          let sf = arguments.first!
                          try sf.eval(vm, result)
                          let s = vm.register(result)
                          
                          if s.type != Core.packageType {
                              throw EmitError("Expected package: \(s.dump(vm))",
                                              sf.location)
                          }

                          let ids: [String] = try arguments[1...].map {f in
                              let id = f.cast(forms.Id.self)

                              if id == nil {
                                  throw EmitError("Expected id: \(f)", f.location)
                              }

                              return id!.value
                          }
                          
                          vm.currentPackage.importFrom(s.cast(Core.packageType), ids)
                      })

            bindMacro("swap!", ["left1", "right1"],
                      {(vm, arguments, result, location) in
                          for i in stride(from: 0, to: arguments.count, by: 2) {
                              let lf = arguments[i]
                              let lr = lf.getRegister(vm)

                              if lr == nil {
                                  throw EmitError("Expected register: \(lf)", lf.location)
                              }

                              let rf = arguments[i]
                              let rr = rf.getRegister(vm)

                              if rr == nil {
                                  throw EmitError("Expected register: \(rf)", rf.location)
                              }

                              vm.emit(ops.SwapRegisters.make(lr!, rr!))
                          }
                      })
        }
    }
}
