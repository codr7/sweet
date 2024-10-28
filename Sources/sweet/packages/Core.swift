extension packages {
    class Core: Package {
        static let nilType = NilType("Nil", [])
        static let anyType = AnyType("Any")

        static let macroType = MacroType("Macro", [anyType])
        static let metaType = MetaType("Meta", [anyType])
        static let packageType = PackageType("Package", [anyType])
        static let registerType = RegisterType("Register", [anyType])
        
        static let NIL = Value(Core.nilType, ())
        
        override func setup(_ vm: VM) {
            bind(Core.anyType)
            bind(Core.macroType)
            bind(Core.metaType)
            bind(Core.nilType)
            bind(Core.packageType)
            bind(Core.registerType)

            self["_"] = Core.NIL

            bindMacro("swap", ["left1", "right1"],
                      {(vm, arguments, result, location) throws(EmitError) in
                          for i in stride(from: 0, to: arguments.count, by: 2) {
                              let lf = arguments[i]
                              let lid = lf.cast(forms.Id.self)

                              if lid == nil {
                                  throw EmitError("Expected id: \(lf)", lf.location)
                              }

                              let lv = vm.currentPackage[lid!.value]

                              if lv == nil {
                                  throw EmitError("Misssing value: \(lf)", lf.location)
                              }

                              if lv!.type != packages.Core.registerType {
                                  throw EmitError("Expected register: \(lv!)", lf.location)
                              }
                                                            
                              let lr = lv!.cast(Core.registerType)
                              let rf = arguments[i]
                              let rid = rf.cast(forms.Id.self)

                              if rid == nil {
                                  throw EmitError("Expected id: \(rf)", rf.location)
                              }
                              
                              let rv = vm.currentPackage[rid!.value]

                              if rv == nil {
                                  throw EmitError("Missing target: \(rf)", rf.location)
                              }

                              if rv!.type != packages.Core.registerType {
                                  throw EmitError("Expected register: \(rv!)", lf.location)
                              }

                              let rr = rv!.cast(Core.registerType)
                              vm.emit(ops.SwapRegisters.make(lr, rr))
                          }
                      })
        }
    }
}
