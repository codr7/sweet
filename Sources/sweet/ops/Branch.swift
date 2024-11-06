extension ops {
    struct Branch {
        static let conditionStart = opCodeWidth
        static let conditionWidth = registerWidth

        static let skipStart = conditionStart + conditionWidth
        static let skipWidth = pcWidth

        static func condition(_ op: Op) -> Register { decodeRegister(op, conditionStart) }
        static func skip(_ op: Op) -> PC { PC(decode(op, skipStart, skipWidth)) }
         
        static func make(_ condition: Register, _ skip: PC) -> Op {
            return encode(OpCode.Branch) +
              encodeRegister(condition, conditionStart) +
              encodePc(skip, skipStart);
        }

        static func dump(_ vm: VM, _ op: Op) -> String {
            let c = condition(op)
            return "condition: \(c)=\(vm.registers[c].dump(vm)) skip: \(skip(op))"
        }
    }
}
