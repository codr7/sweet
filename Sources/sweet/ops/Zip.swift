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
            return encode(OpCode.Zip) +
              encodeRegister(left, leftStart) +
              encodeRegister(right, rightStart) +
              encodeRegister(result, resultStart)

        }
    }
}