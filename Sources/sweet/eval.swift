extension VM {
    func eval(_ startPc: PC) throws {
        pc = startPc
        
        NEXT:
          do {
            let op = code[Int(pc)]

            switch ops.decode(op) {
            case .Call:
                let t = registers[ops.Call.target(op)]
                let a = ops.Call.argument(op)
                let r = ops.Call.result(op)
                let l = tags[ops.Call.location(op)] as! Location
                
                var arguments: [Value] = []
                for i in 0..<ops.Call.arity(op) { arguments.append(registers[a+i]) }

                try t.call(self, arguments, r, l)
            case .Goto:
                pc = ops.Goto.pc(op)
            case .InitMethod:
                let t = registers[ops.InitMethod.target(op)]
                let m = t.cast(packages.Core.methodType) as! SweetMethod
                
                m.closure = m.closure.map {c in
                    (c.value.type == packages.Core.registerType)
                      ? Closure(c.id,
                                c.target,
                                registers[c.value.cast(packages.Core.registerType)])
                      : c
                }

                pc = ops.InitMethod.skip(op)
            case .Return:
                let c = calls.removeLast()
                for (r, v) in c.frame { registers[r] = v }
                pc = c.returnPc
            case .SetRegister:
                let t = ops.SetRegister.target(op)
                let v = tags[ops.SetRegister.value(op)] as! Value
                registers[t] = v 
                pc += 1
            case .SwapRegisters:
                let lr = ops.SwapRegisters.left(op)
                let rr = ops.SwapRegisters.right(op)
                let lv = registers[lr]
                registers[lr] = registers[rr]
                registers[rr] = lv
                pc += 1
            case .Stop:
                pc += 1
                return
            case .Unzip:
                let t = registers[ops.Unzip.target(op)].cast(packages.Core.pairType)
                let lr = ops.Unzip.left(op)
                let rr = ops.Unzip.right(op)
                if lr != nil {registers[lr!] = t.0}
                if rr != nil {registers[rr!] = t.1}
                pc += 1                
            case .Zip:
                let l = registers[ops.Zip.left(op)]
                let r = registers[ops.Zip.right(op)]
                registers[ops.Zip.result(op)] = Value(packages.Core.pairType, (l, r))
                pc += 1
            }
            
            continue NEXT
        }
    }
}

class EvalError: BaseError {}
