extension ops {
    struct ClearRegister {
        static let targetStart = opCodeWidth
        static let targetWidth = registerWidth

        static func target(_ op: Op) -> Register { decodeRegister(op, targetStart) }
        
        static func make(_ target: Register) -> Op {
            return encode(OpCode.ClearRegister) + encodeRegister(target, targetStart)
        }
    }
}
