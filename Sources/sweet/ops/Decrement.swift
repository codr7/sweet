extension ops {
    struct Decrement {
        static let targetStart = opCodeWidth
        static let targetWidth = registerWidth

        static let deltaFlag = targetStart + targetWidth
        static let deltaStart = deltaFlag + 1
        static let deltaWidth = registerWidth

        static let resultStart = deltaStart + deltaWidth
        static let resultWidth = registerWidth

        static func target(_ op: Op) -> Register { decodeRegister(op, targetStart) }

        static func delta(_ op: Op) -> Register? {
            decodeFlag(op, deltaFlag) ? decodeRegister(op, deltaStart) : nil
        }

        static func result(_ op: Op) -> Register { decodeRegister(op, resultStart) }
        
        static func make(_ target: Register, _ delta: Register?, _ result: Register) -> Op {
            encode(OpCode.Decrement) +
              encodeRegister(target, targetStart) +
              encodeFlag(delta != nil, deltaFlag) +
              ((delta == nil) ? 0 : encodeRegister(delta!, deltaStart)) +
              encodeRegister(result, resultStart)
        }

        static func dump(_ vm: VM, _ op: Op) -> String {
            let t = target(op)
            let d = delta(op)
            let r = result(op)     
            return "target: \(t) delta: \((d == nil) ? "n/a" : "\(d!)") result: \(r)"
        }

        static func trace(_ vm: VM, _ op: Op) -> String {
            let t = target(op)
            let d = delta(op)
            let r = result(op)     
            return "target: \(t)=\(vm.registers[t].dump(vm)) delta: \((d == nil) ? "n/a" : vm.registers[d!].dump(vm)) result: \(r)=\(vm.registers[r].dump(vm))"
        }
    }
}
