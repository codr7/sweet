extension ops {
    struct Stop {
        static func make() -> Op { encode(OpCode.Stop) }
    }
}
