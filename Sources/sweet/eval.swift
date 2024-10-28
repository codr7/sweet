extension VM {
    func eval(_ startPc: PC) throws(EvalError) {
        pc = startPc
        
        NEXT:
          do {
            let op = code[Int(pc)]

            switch ops.decode(op) {
            case .Goto:
                pc = ops.Goto.pc(op)
            case .SetRegister:
                register(ops.SetRegister.target(op), tag(ops.SetRegister.value(op)))
                pc += 1
            case .SwapRegisters:
                let v = register(ops.SwapRegisters.left(op))
                register(ops.SwapRegisters.left(op), register(ops.SwapRegisters.right(op)))
                register(ops.SwapRegisters.right(op), v)
                pc += 1
            case .Stop:
                pc += 1
                return
            }
            
            continue NEXT
        }
    }
}

class EvalError: BaseError {}
