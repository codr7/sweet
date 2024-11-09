extension ops {
    struct SwapRegisters {
        static let leftStart = opCodeWidth;
        static let leftWidth = registerWidth;
        static let rightStart = leftStart + leftWidth;
        static let rightWidth = registerWidth

        static func left(_ op: Op) -> Register { decodeRegister(op, leftStart) }
        static func right(_ op: Op) -> Register { decodeRegister(op, rightStart) }
        
        static func make(_ left: Register, _ right: Register) -> Op {
            encode(OpCode.SwapRegisters) +
              encodeRegister(left, leftStart) +
              encodeRegister(right, rightStart)
        }

        static func dump(_ vm: VM, _ op: Op) -> String {
            let l = left(op)
            let r = right(op)
            
            return "left: \(l) right: \(r)"
        }  

        static func trace(_ vm: VM, _ op: Op) -> String {
            let l = left(op)
            let r = right(op)

            return "left: \(l)=\(vm.registers[l].dump(vm)) right: \(r)=\(vm.registers[r].dump(vm))"
        }  
    }
}
