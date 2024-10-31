extension ops {
    struct Check {
        static let expectedStart = opCodeWidth
        static let expectedWidth = registerWidth

        static let resultStart = expectedStart + expectedWidth
        static let resultWidth = registerWidth

        static let locationStart = resultStart + resultWidth
        static let locationWidth = tagWidth

        static func expected(_ op: Op) -> Register { decodeRegister(op, expectedStart) }
        static func result(_ op: Op) -> Register { decodeRegister(op, resultStart) }
        static func location(_ op: Op) -> Tag { decodeTag(op, locationStart) }
        
        static func make(_ vm: VM,
                         _ expected: Register,
                         _ result: Register,
                         _ location: Location) -> Op {
            let lt = vm.tag(location)
            
            return encode(OpCode.Check) +
              encodeRegister(expected, expectedStart) +
              encodeRegister(result, resultStart) +
              encodeTag(lt, locationStart); 
        }
    }
}
