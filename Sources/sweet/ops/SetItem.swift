extension ops {
    struct SetItem {
        static let targetStart = opCodeWidth
        static let targetWidth = registerWidth

        static let indexStart = targetStart + targetWidth

        static let valueStart = indexStart + indexWidth
        static let valueWidth = registerWidth
        
        static func target(_ op: Op) -> Register { decodeRegister(op, targetStart) }
        static func index(_ op: Op) -> Int { Int(decode(op, indexStart, indexWidth)) }
        static func value(_ op: Op) -> Register { decodeRegister(op, valueStart) }
        
        static func make(_ target: Register, _ index: Int, _ value: Register) -> Op {
            encode(OpCode.SetItem) +
              encodeRegister(target, targetStart) +
              encode(index, indexStart, indexWidth) +
              encodeRegister(value, valueStart);
        }

        static func dump(_ vm: VM, _ op: Op) -> String {
            let t = target(op)
            let v = value(op)
            return "target: \(t)=\(vm.registers[t].dump(vm)) index: \(index(op)) value: \(v)=\(vm.registers[v].dump(vm))"
        }
    }
}
