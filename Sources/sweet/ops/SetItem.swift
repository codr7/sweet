extension ops {
    struct SetItem {
        static let targetStart = opCodeWidth
        static let targetWidth = registerWidth
        static let indexStart = targetStart + targetWidth
        static let valueStart = indexStart + indexWidth

        static func target(_ op: Op) -> Register { decodeRegister(op, targetStart) }
        static func index(_ op: Op) -> Int { Int(decode(op, indexStart, indexWidth)) }
        static func value(_ op: Op) -> Register { decodeRegister(op, valueStart) }
        
        static func make(_ target: Register, _ index: Int, _ value: Register) -> Op {
            encode(OpCode.SetItem) +
              encodeRegister(target, targetStart) +
              encode(index, indexStart, indexWidth) +
              encodeRegister(value, valueStart);
        }
    }
}
