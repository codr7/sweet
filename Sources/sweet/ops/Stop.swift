extension ops {
    struct Stop {
        static func make() -> Op { Op(OpCode.stop.rawValue) }
    }
}
