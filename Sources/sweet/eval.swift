import SystemPackage

extension VM {
    func eval(_ startPc: PC) throws {
        pc = startPc
        
        NEXT:
          do {
            let op = code[Int(pc)]
            //print("\(pc) \(ops.decode(op)) \(ops.trace(self, op))")
            
            switch ops.decode(op) {
            case .Benchmark:
                do {
                    let startPc = pc + 1
                    let n = registers[ops.Benchmark.n(op)].cast(packages.Core.intType);

                    let t = try ContinuousClock().measure {
                        for _ in 0..<n { try eval(startPc) }
                    } 
                    
                    registers[ops.Benchmark.result(op)] = Value(packages.Core.timeType, t)
                }
            case .Branch:
                if registers[ops.Branch.condition(op)].toBit() { pc += 1 }
                else { pc = ops.Branch.skip(op) }
            case .Call:
                do {
                    let t = registers[ops.Call.target(op)]
                    let a = ops.Call.argument(op)
                    let r = ops.Call.result(op)
                    let l = tags[ops.Call.location(op)] as! Location
                    
                    var arguments: [Value] = []
                    for i in 0..<ops.Call.arity(op) { arguments.append(registers[a+i]) }
                    try t.call(self, arguments, r, l)
                }
            case .CallTag:
                do {
                    let t = tags[ops.Call.target(op)] as! Value
                    let a = ops.Call.argument(op)
                    let r = ops.Call.result(op)
                    let l = tags[ops.Call.location(op)] as! Location
                    
                    var arguments: [Value] = []
                    for i in 0..<ops.Call.arity(op) { arguments.append(registers[a+i]) }
                    try t.call(self, arguments, r, l)
                }
            case .CallTail:
                do {
                    let c = calls.removeLast()
                    let m = tags[ops.CallTail.target(op)] as! SweetMethod
                    let l = tags[ops.CallTail.location(op)] as! Location
                    let a = ops.CallTail.argument(op);
                    calls.append(Call(self, c, m, l))
                    
                    for i in 0..<min(m.sweetArguments.count, ops.CallTail.arity(op)) {
                        let ma = m.sweetArguments[i]
                        if !ma.id.isNone { registers[ma.target] = registers[a + i] }
                    }
                    
                    pc = m.startPc
                }
            case .Check:
                do {
                    let ev = registers[ops.Check.expected(op)]
                    var av = registers[ops.Check.result(op)]
                    let opAv = av

                    if ev.type == packages.Core.bitType &&
                         av.type != packages.Core.bitType {
                        av = Value(packages.Core.bitType, av.toBit())
                    }

                    if (av != ev) {
                        let evs = ev.dump(self)
                        let avs = opAv.dump(self)
                        throw EvalError("Check failed: expected \(evs), actual: \(avs)",
                                        tags[ops.Check.location(op)] as! Location)
                    }

                    pc += 1
                }
            case .ClearRegister:
                registers[ops.ClearRegister.target(op)] = packages.Core.NONE
                pc += 1
            case .Copy:
                do {
                    let from = ops.Copy.from(op)
                    let to = ops.Copy.to(op)
                    registers[to] = registers[from]
                    pc += 1
                }
            case .Decrement:
                do {
                    let dv = if let dr = ops.Decrement.delta(op) {
                        registers[dr].cast(packages.Core.intType)
                    } else {
                        1
                    }
                    
                    let t = ops.Decrement.target(op)

                    let v = Value(packages.Core.intType,
                                  registers[t].cast(packages.Core.intType) - dv)
                    
                    registers[t] = v
                    let r = ops.Decrement.result(op)
                    if r != t { registers[r] = v }
                    pc += 1
                }
            case .Goto:
                pc = ops.Goto.pc(op)
            case .InitList:
                do {
                    let c = ops.InitList.count(op)
                    let v = List(repeating: packages.Core.NONE, count: c)
                    registers[ops.InitList.target(op)] = Value(packages.Core.listType, v)
                    pc += 1
                }
            case .InitMethod:
                do {
                    let m = tags[ops.InitMethod.target(op)] as! SweetMethod

                    m.closure = m.closure.map {c in
                        let cr = c.value.cast(packages.Core.bindingType).register
                        return Closure(c.id, c.target, registers[cr])
                    }

                    pc = ops.InitMethod.skip(op)
                }
            case .Return:
                do {
                    let c = calls.removeLast()
                    let t = c.target
                    let r = t.result
                    
                    let rv = (t.resultType != nil) 
                      ? registers[r]
                      : packages.Core.NONE
                    
                    for (fr, fv) in c.frame { registers[fr] = fv }
                    if c.result != r { registers[c.result] = rv }
                    if let cn = calls.last, cn.target.resultType != nil  { registers[cn.target.result] = rv }
                    pc = c.returnPc
                }
            case .SetItem:
                do {
                    let t = ops.SetItem.target(op)
                    let i = ops.SetItem.index(op)
                    let v = registers[ops.SetItem.value(op)]
                    registers[t].setItem(i, v)
                    pc += 1
                }
            case .SetLoadPath:
                loadPath = tags[ops.SetLoadPath.path(op)] as! FilePath;
                pc += 1
            case .SetRegister:
                do {
                    let t = ops.SetRegister.target(op)
                    let v = tags[ops.SetRegister.value(op)] as! Value
                    registers[t] = v 
                    pc += 1
                }
            case .SwapRegisters:
                do {
                    let lr = ops.SwapRegisters.left(op)
                    let rr = ops.SwapRegisters.right(op)
                    let lv = registers[lr]
                    registers[lr] = registers[rr]
                    registers[rr] = lv
                    pc += 1
                }
            case .Stop:
                pc += 1
                return
            case .Unzip:
                do {
                    let t = registers[ops.Unzip.target(op)].cast(packages.Core.pairType)
                    let lr = ops.Unzip.left(op)
                    let rr = ops.Unzip.right(op)
                    if lr != nil {registers[lr!] = t.0}
                    if rr != nil {registers[rr!] = t.1}
                    pc += 1
                }
            case .Zip:
                do {
                    let l = registers[ops.Zip.left(op)]
                    let r = registers[ops.Zip.right(op)]
                    registers[ops.Zip.result(op)] = Value(packages.Core.pairType, (l, r))
                    pc += 1
                }
            }
            
            continue NEXT
        }
    }
}

final class EvalError: BaseError, @unchecked Sendable {}
