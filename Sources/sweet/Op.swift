typealias Op = UInt128;

enum OpCode: UInt8 {
    case Branch
    case Call
    case Check
    case ClearRegister
    case Copy
    case Decrement
    case Goto
    case InitList
    case InitMethod
    case Return
    case SetItem
    case SetLoadPath
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
    static let countWidth: UInt8 = 20
    static let indexWidth: UInt8 = 20
    
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

    static func dump(_ vm: VM, _ op: Op) -> String {
        switch decode(op) {
        case .Branch:
            Branch.dump(vm, op)
        case .Call:
            Call.dump(vm, op)
        case .Check:
            ""
        case .ClearRegister:
            ClearRegister.dump(vm, op)
        case .Copy:
            Copy.dump(vm, op)
        case .Decrement:
            Decrement.dump(vm, op)
        case .Goto:
            Goto.dump(vm, op)
        case .InitList:
            InitList.dump(vm, op)
        case .InitMethod:
            InitMethod.dump(vm, op)
        case .Return:
            Return.dump(vm, op)
        case .SetItem:
            SetItem.dump(vm, op)
        case .SetLoadPath:
            SetLoadPath.dump(vm, op)
        case .SetRegister:
            SetRegister.dump(vm, op)
        case .SwapRegisters:
            SwapRegisters.dump(vm, op)
        case .Stop:
            ""
        case .Unzip:
            Unzip.dump(vm, op)
        case .Zip:
            Zip.dump(vm, op)
        }
    }
}
