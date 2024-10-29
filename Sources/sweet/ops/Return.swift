extension ops {
    struct Return {
        static func make() -> Op { encode(OpCode.Return) }
    }
}
