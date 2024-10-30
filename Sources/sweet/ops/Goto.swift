extension ops {
    struct Goto {
        static let pcStart = opCodeWidth
        static func pc(_ op: Op) -> Register { decodePc(op, pcStart) }
        static func make(_ pc: PC) -> Op { encode(OpCode.Goto) + encodePc(pc, pcStart); }
    }
}
