import SystemPackage

extension packages {
    class Core: Package {
        static let noneType = NoneType("None", [])
        static let anyType = AnyType("Any", [])

        static let bindingType = BindingType("Binding", [anyType])
        static let bitType = BitType("Bit", [anyType])
        static let intType = IntType("Int", [anyType])
        static let listType = ListType("List", [anyType])
        static let macroType = MacroType("Macro", [anyType])
        static let metaType = MetaType("Meta", [anyType])
        static let methodType = MethodType("Method", [anyType])
        static let packageType = PackageType("Package", [anyType])
        static let pairType = PairType("Pair", [anyType])
        static let pathType = PathType("Path", [anyType])
        static let stringType = StringType("String", [anyType])
        
        static let NONE = Value(Core.noneType, ())
        
        static let T = Value(Core.bitType, true)
        static let F = Value(Core.bitType, false)
        
        override func initBindings(_ vm: VM) {
            bind(Core.anyType)
            bind(Core.bindingType)
            bind(Core.bitType)
            bind(Core.intType)
            bind(Core.listType)
            bind(Core.macroType)
            bind(Core.metaType)
            bind(Core.methodType)
            bind(Core.noneType)
            bind(Core.packageType)
            bind(Core.pairType)
            bind(Core.pathType)
            bind(Core.stringType)
            
            self["_"] = Core.NONE
            self["T"] = Core.T
            self["F"] = Core.F

            bindMacro("^", ["id", "args"], Core.methodType,
                      {(vm, arguments, result, location) in
                          let idf = arguments.first!
                          
                          let id =
                            if let idf = idf.tryCast(forms.Id.self) { idf.value }
                            else {
                                throw EmitError("Expected id: \(idf.dump(vm))",
                                                idf.location)
                            }
                          
                          var mas: [Argument] = []
                          let isConst = !id.isEmpty && id.last! != "!"
                          let isVararg = false
                          var resultType: ValueType? = nil
                          let asf = arguments[1]
                          
                          if let asf = asf.tryCast(forms.List.self) {
                              var fs = asf.items
                              while !fs.isEmpty {
                                  let af = fs.removeFirst()

                                  if af.isSeparator {
                                      if fs.isEmpty { break }
                                      let af = fs.removeFirst()
                                      let av = af.getValue(vm)

                                      if let rt = av?.tryCast(packages.Core.metaType) {
                                          resultType = rt
                                      } else {
                                          throw EmitError("Invalid result type: \(af.dump(vm))",
                                                          af.location)
                                      }

                                      if !fs.isEmpty {
                                          throw EmitError("Invalid result type",
                                                          fs.first!.location)
                                      }

                                      break
                                  }

                                  if let idf = af.tryCast(forms.Id.self) {
                                      let ar = idf.isNone ?  -1 : vm.nextRegister 
                                      var a = Argument(idf.value, ar)
                                      
                                      if !fs.isEmpty {
                                          if let t = fs.first!
                                               .getValue(vm)?
                                               .tryCast(packages.Core.metaType) {
                                              a.type = t
                                              fs.removeFirst()
                                          }
                                      }
                                      
                                      mas.append(Argument(idf.value, ar))
                                  }
                              }
                          } else {
                              throw EmitError("Expected argument list: \(asf.dump(vm))",
                                              asf.location)
                          }
                          
                          let body = Forms(arguments[2...])
                          let mpc = vm.emit(ops.Stop.make())

                          let m = SweetMethod(id,
                                              mas,
                                              vm.nextRegister, resultType,
                                              location,
                                              isConst: isConst,
                                              isVararg: isVararg)

                          var bodyIds = body.ids
                          bodyIds.remove(id)
                          for a in mas { bodyIds.remove(a.id) }
                          try m.initClosure(vm, bodyIds)
                          let v = Value(Core.methodType, m)

                          if m.isConst, let cv = body.getConstViolation(vm) {
                              throw EmitError("Const violation in \(m): \(cv.dump(vm))",
                                              cv.location)
                          }

                          if !id.isNone { vm.currentPackage[id] = v }
                          
                          try vm.doPackage(nil) {
                              for a in mas {
                                  if !a.id.isNone {
                                      vm.currentPackage[a.id] =
                                        Value(Core.bindingType, Binding(a.target, a.type))
                                  }
                              }

                              if let rt = m.resultType {
                                  vm.currentPackage["result"] =
                                    Value(Core.bindingType, Binding(m.result, rt))
                              }
                              
                              try body.emit(vm, m.result);
                          }

                          vm.emit(ops.Return.make())
                          vm.code[mpc] = ops.InitMethod.make(vm, m, vm.emitPc)
                          vm.emit(ops.SetRegister.make(vm, result, v))
                      })

            bindMethod("=", ["x", "y", "z?"], Core.bitType,
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

            bindMethod("<", ["x", "y", "z?"], Core.bitType,
                       {(vm, arguments, result, location) in
                           let l = arguments.first!.cast(Core.intType)
                           var rv = true
                           
                           for r in arguments[1...] {
                               if l >= r.cast(Core.intType) {
                                   rv = false
                                   break
                               }
                           }
                           
                           vm.registers[result] = Value(Core.bitType, rv)
                       })

            bindMethod("+", ["x", "y?"], Core.intType,
                       {(vm, arguments, result, location) in
                           var rv = arguments.first!.cast(Core.intType)
                           for v in arguments[1...] { rv += v.cast(Core.intType) }
                           vm.registers[result] = Value(Core.intType, rv)
                       })

            bindMacro("check", ["x"], nil,
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

            bindMethod("count", ["x", "y?"], Core.intType,
                       {(vm, arguments, result, location) in
                           var n = 0
                           
                           for a in arguments {
                               if let ct = a.type as? CountTrait { n += ct.count!(a) }
                               else {
                                   throw EvalError("Not countable: \(a.dump(vm))",
                                                   location)
                               }
                           }

                           vm.registers[result] = Value(Core.intType, n)
                      })

            bindMacro("dec!", ["value", "delta?"], nil,
                      {(vm, arguments, result, location) in
                          let a = arguments[0]
                          
                          if let bv = arguments[0].getValue(vm),
                             let b = bv.tryCast(Core.bindingType) {
                                 if (b.type ?? Core.intType) != Core.intType {
                                     throw EmitError("Expected Int: \(bv.dump(vm))",
                                                     location)
                                 }

                                 var dr: Register? = nil
                                 
                                 if arguments.count > 1 {
                                     let r = vm.nextRegister
                                     try arguments[1].emit(vm, r)
                                     dr = r
                                 }

                                 vm.emit(ops.Decrement.make(b.register, dr, result))
                          } else {
                              throw EmitError("Invalid decrement target: \(a.dump(vm))",
                                              location)
                          }
                      })
            
            bindMacro("import!", ["source", "id1?"], nil,
                      {(vm, arguments, result, location) in
                          vm.registers[result] = Core.NONE
                          var sf = arguments.first!
                          var isSplat = false
                          
                          if let f = sf.tryCast(forms.Splat.self) {
                              sf = f.target
                              isSplat = true
                          }
                          
                          try sf.eval(vm, result)
                          let s = vm.registers[result]

                          if let sp = s.tryCast(Core.packageType) {
                              let ids: [String] = isSplat
                                ? sp.ids
                                : try arguments[1...].map {f in
                                    let id = f.tryCast(forms.Id.self)
                                    
                                    if id == nil {
                                        throw EmitError("Expected id: \(f)", f.location)
                                    }
                                    
                                    return id!.value
                                }
                              
                              vm.currentPackage.importFrom(s.cast(Core.packageType), ids)
                          }
                          else {
                              throw EmitError("Expected package: \(s.dump(vm))",
                                              sf.location)
                          }
                      })

            bindMethod("is", ["x", "y", "z?"], Core.bitType,
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

            bindMethod("isa", ["value", "x", "y?"], Core.bitType,
                       {(vm, arguments, result, location) in
                           let v = arguments[0]

                           let rv = try arguments[1...].allSatisfy {
                               if let t = $0.tryCast(packages.Core.metaType) { 
                                   v.type.isDerived(from: t)
                               } else {
                                   throw EvalError("Expected type: \($0.dump(vm))",
                                                   location) 
                               }
                           }
                           
                           vm.registers[result] = Value(packages.Core.bitType, rv)
                       })
            
            bindMacro("load!", ["path1"], nil, 
                      {(vm, arguments, result, location) in
                          for f in arguments {
                              if let p = try f.eval(vm).tryCast(Core.pathType) {
                                  try vm.load(p, result)
                              } else {
                                  throw EmitError("Expected path: \(f.dump(vm))",
                                                  f.location)
                              }
                          }
                      })

            bindMethod("path", ["value"], Core.pathType,
                       {(vm, arguments, result, location) in
                           let v = arguments.first!
                           
                           if let sv = v.tryCast(Core.stringType) {
                               vm.registers[result] = Value(Core.pathType, FilePath(sv))
                           } else {
                               throw EvalError("Expected string: \(v.dump(vm))", location)
                           }
                       })
                           
                          
            bindMacro("swap!", ["left1", "right1"], nil, 
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

            bindMethod("type", ["x", "y?"], vm.maybe(Core.metaType), 
                       {(vm, arguments, result, location) in
                           var ts = Set<TypeId>(arguments[0].type.parents)
                           
                           for a in arguments[1...] {
                               ts = ts.intersection(a.type.parents)
                           }

                           if ts.isEmpty {
                               vm.registers[result] = packages.Core.NONE
                           } else {
                               var sts = Array(ts)
                               sts.sort()
                               vm.registers[result] = Value(packages.Core.metaType,
                                                            typeLookup[sts.last!]!)
                           }
                       })
        }
    }
}
