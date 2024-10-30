extension ops {
    struct InitList {
        static let targetStart = opCodeWidth
        static let targetWidth = registerWidth
        static let countStart = targetStart + targetWidth

        static func target(_ op: Op) -> Register { decodeRegister(op, targetStart) }
        static func count(_ op: Op) -> Int { Int(decode(op, countStart, countWidth)) }
        
        static func make(_ target: Register, _ count: Int) -> Op {
            encode(OpCode.InitList) +
              encodeRegister(target, targetStart) +
              encode(count, countStart, countWidth);
        }
    }
}
