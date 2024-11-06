extension ops {
    struct Zip {
        static let leftStart = opCodeWidth
        static let leftWidth = registerWidth
        
        static let rightStart = leftStart + leftWidth
        static let rightWidth = registerWidth

        static let resultStart = rightStart + rightWidth
        static let resultWidth = registerWidth

        static func left(_ op: Op) -> Register { decodeRegister(op, leftStart) }
        static func right(_ op: Op) -> Register { decodeRegister(op, rightStart) }
        static func result(_ op: Op) -> Register { decodeRegister(op, resultStart) }
        
        static func make(_ left: Register, _ right: Register, _ result: Register) -> Op {
            encode(OpCode.Zip) +
              encodeRegister(left, leftStart) +
              encodeRegister(right, rightStart) +
              encodeRegister(result, resultStart)

        }

        static func dump(_ vm: VM, _ op: Op) -> String {
            let lr = left(op)
            let rr = right(op)
            let r = result(op)

            return "left: \(lr) \(vm.registers[lr].dump(vm)) right: \(rr) \(vm.registers[rr].dump(vm)) result: \(r) \(vm.registers[r].dump(vm)) "
        }
    }
}
