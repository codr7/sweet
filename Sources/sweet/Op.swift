typealias Op = UInt128;

enum OpCode: UInt8 {
    case Call
    case Goto
    case SetRegister
    case SwapRegisters
    case Stop
    case Unzip
    case Zip
}

struct ops {
    static let opCodeWidth: UInt8 = 6
    static let pcWidth: UInt8 = 20
    static let registerWidth: UInt8 = 20
    static let tagWidth: UInt8 = 20

    static func encode<T>(_ value: T, _ offset: UInt8, _ width: UInt8) -> Op
      where T: BinaryInteger {
        (Op(value) & ((Op(1) << width) - 1)) << offset
    }

    static func decode(_ op: Op, _ offset: UInt8, _ width: UInt8) -> Op {
        (op >> offset) & ((Op(1) << width) - 1)
    }


    static func encode(_ value: OpCode) -> Op { encode(value.rawValue, 0, opCodeWidth) }

    static func decode(_ op: Op) -> OpCode {
        OpCode(rawValue: UInt8(decode(op, 0, opCodeWidth)))!
    }

    
    static func encodeFlag(_ value: Bool, _ offset: UInt8) -> Op {
        encode(value ? 1 : 0, offset, 1)
    }

    static func decodeFlag(_ op: Op, _ offset: UInt8) -> Bool {
        decode(op, offset, 1) == 1
    }

    
    static func encodePc(_ value: PC, _ offset: UInt8) -> Op {
        encode(value, offset, pcWidth)
    }

    static func decodePc(_ op: Op, _ offset: UInt8) -> PC {
        PC(decode(op, offset, pcWidth))
    }

    
    static func encodeRegister(_ value: Register, _ offset: UInt8) -> Op {
        encode(value, offset, registerWidth)
    }

    static func decodeRegister(_ op: Op, _ offset: UInt8) -> Register {
        Register(decode(op, offset, registerWidth))
    }

    
    static func encodeTag(_ value: Tag, _ offset: UInt8) -> Op {
        encode(value, offset, tagWidth)
    }

    static func decodeTag(_ op: Op, _ offset: UInt8) -> Register {
        Tag(decode(op, offset, registerWidth))
    }
}
