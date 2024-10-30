extension ops {
    struct InitMethod {
        static let targetStart = opCodeWidth
        static let targetWidth = registerWidth
        static let skipStart = targetStart + targetWidth
        static let skipWidth = pcWidth

        static func target(_ op: Op) -> Register { decodeRegister(op, targetStart) }
        static func skip(_ op: Op) -> PC { decodePc(op, skipStart) }
        
        static func make(_ target: Register, _ skip: PC) -> Op {
            encode(OpCode.InitMethod) +
              encodeRegister(target, targetStart) +
              encodePc(skip, skipStart); 
        }
    }
}
