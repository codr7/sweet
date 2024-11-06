extension ops {
    struct Copy {
        static let fromStart = opCodeWidth
        static let fromWidth = registerWidth

        static let toStart = fromStart + fromWidth
        static let toWidth = registerWidth

        static func from(_ op: Op) -> Register { decodeRegister(op, fromStart) }
        static func to(_ op: Op) -> Register { decodeRegister(op, toStart) }
        
        static func make(_ from: Register, _ to: Register) -> Op {
            encode(OpCode.Copy) +
              encodeRegister(from, fromStart) +
              encodeRegister(to, toStart)
        }

        static func dump(_ vm: VM, _ op: Op) -> String {
            let f = from(op)
            return "from: \(f)=\(vm.registers[f].dump(vm)) to: \(to(op))"
        }
    }
}
