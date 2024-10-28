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
                              let lv = lf.getValue(vm)

                              if lv == nil {
                                  throw EmitError("Missing source: \(lf)", lf.location)
                              }

                              let lr = lv!.cast(Core.registerType)
                              let rf = arguments[i]
                              let rv = rf.getValue(vm)

                              if rv == nil {
                                  throw EmitError("Missing target: \(rf)", rf.location)
                              }

                              let rr = rv!.cast(Core.registerType)
                              vm.emit(ops.SwapRegisters.make(lr, rr))
                          }
                      })
        }
    }
}
