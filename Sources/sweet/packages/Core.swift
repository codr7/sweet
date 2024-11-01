extension packages {
    class Core: Package {
        static let noneType = NoneType("None", [])
        static let anyType = AnyType("Any")

        static let bitType = BitType("Bit", [anyType])
        static let intType = IntType("Int", [anyType])
        static let listType = ListType("List", [anyType])
        static let macroType = MacroType("Macro", [anyType])
        static let metaType = MetaType("Meta", [anyType])
        static let methodType = MethodType("Method", [anyType])
        static let packageType = PackageType("Package", [anyType])
        static let pairType = PairType("Pair", [anyType])
        static let registerType = RegisterType("Register", [anyType])
        
        static let NONE = Value(Core.noneType, ())
        
        static let T = Value(Core.bitType, true)
        static let F = Value(Core.bitType, false)
        
        override func initBindings(_ vm: VM) {
            bind(Core.anyType)
            bind(Core.bitType)
            bind(Core.intType)
            bind(Core.listType)
            bind(Core.macroType)
            bind(Core.metaType)
            bind(Core.methodType)
            bind(Core.noneType)
            bind(Core.packageType)
            bind(Core.pairType)
            bind(Core.registerType)

            self["_"] = Core.NONE
            self["T"] = Core.T
            self["F"] = Core.F

            bindMacro("^", ["id", "args"],
                      {(vm, arguments, result, location) in
                          let idf = arguments.first!
                          
                          let id =
                            if let idf = idf.cast(forms.Id.self) { idf.value }
                            else {
                                throw EmitError("Expected id: \(idf.dump(vm))",
                                                idf.location)
                            }
                          
                          var mas: [Argument] = []
                          let asf = arguments[1]
                          
                          if let asf = asf.cast(forms.List.self) {
                              for af in asf.items {
                                  if let idf = af.cast(forms.Id.self) {
                                      let ar = idf.isNil ?  -1 : vm.nextRegister 
                                      mas.append(Argument(idf.value, ar))
                                  }
                              }
                          } else {
                              throw EmitError("Expected argument list: \(asf.dump(vm))",
                                              asf.location)
                          }
                          
                          let mos = BaseMethod.Options()
                          let m = SweetMethod(id, mas, vm.nextRegister, mos, location)
                          let mpc = vm.emit(ops.Stop.make())
                          let v = Value(Core.methodType, m)
                          if !id.isNil { vm.currentPackage[id] = v }
                          
                          try vm.doPackage(nil) {
                              for a in mas {
                                  if !a.id.isNil {
                                      vm.currentPackage[a.id] =
                                        Value(Core.registerType, a.target)
                                  }
                              }

                              try Forms(arguments[2...]).emit(vm, m.result);
                          }

                          vm.emit(ops.Return.make())
                          vm.code[mpc] = ops.InitMethod.make(vm, m, vm.emitPc)
                          vm.emit(ops.SetRegister.make(vm, result, v))
                      })

            bindMethod("=", ["x", "y", "z?"],
                       {(vm, arguments, result, location) in
                           let l = arguments.first!
                           var v = true
                           
                           for r in arguments[1...] {
                               if !l.eqv(r) {
                                   v = false
                                   break
                               }
                           }

                           vm.registers[result] = Value(Core.bitType, v)
                      })

            bindMacro("check", ["x"],
                      {(vm, arguments, result, location) in
                          let er = vm.nextRegister

                          if arguments.count == 1 {
                              try Core.T.emit(vm, er, location)
                              try arguments[0].emit(vm, result)
                          } else {
                              try arguments[0].emit(vm, er)

                              try vm.doPackage(nil) {
                                  try Forms(arguments[1...]).emit(vm, result)
                              }
                          }
                          
                          vm.emit(ops.Check.make(vm, er, result, location))
                      })
            
            bindMacro("import", ["source", "id1?"],
                      {(vm, arguments, result, location) in
                          vm.registers[result] = Core.NONE
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

            bindMethod("is", ["x", "y", "z?"],
                       {(vm, arguments, result, location) in
                           let l = arguments.first!
                           var v = true
                           
                           for r in arguments[1...] {
                               if !l.eq(r) {
                                   v = false
                                   break
                               }
                           }

                           vm.registers[result] = Value(Core.bitType, v)
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
