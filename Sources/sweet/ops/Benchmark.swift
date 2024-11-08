extension ops {
    struct Benchmark {
        static let nStart = opCodeWidth
        static let nWidth = registerWidth
        
        static let resultStart = nStart + nWidth
        static let resultWidth = registerWidth
        
        static func n(_ op: Op) -> Register { decodeRegister(op, nStart) }
        static func result(_ op: Op) -> Register { decodeRegister(op, resultStart) }
        
        static func make(_ n: Register, _ result: Register) -> Op {
            encode(OpCode.Benchmark) +
              encodeRegister(n, nStart) +
              encodeRegister(result, resultStart)
        }
        
        static func dump(_ vm: VM, _ op: Op) -> String {
            let n = n(op)
            let r = result(op)
            return "n: \(n)=\(vm.registers[n].dump(vm)) result: \(r)=\(vm.registers[r].dump(vm))"
        }
    }
}
