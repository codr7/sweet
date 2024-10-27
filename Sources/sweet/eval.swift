extension VM {
    func eval(_ startPc: PC) {
        pc = startPc
        
        NEXT:
          do {
            let op = code[Int(pc)]

            switch ops.decode(op) {
            case .setRegister:
                register(ops.SetRegister.target(op), tag(ops.SetRegister.value(op)))
                pc += 1
            case .stop:
                pc += 1
                return
            }
            
            
            continue NEXT
        }
    }
}
