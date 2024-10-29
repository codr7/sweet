extension ops {
    struct SetRegister {
        static let targetStart = opCodeWidth
        static let targetWidth = registerWidth
        static let valueStart = targetStart + targetWidth
        static let valueWidth = tagWidth

        static func target(_ op: Op) -> Register { decodeRegister(op, targetStart) }
        static func value(_ op: Op) -> Tag { decodeTag(op, valueStart) }
        
        static func make(_ vm: VM, _ target: Register, _ value: Value) -> Op {
            let vt = vm.tag(value)
            
            return encode(OpCode.SetRegister) +
              encodeRegister(target, targetStart) +
              encodeTag(vt, valueStart); 
        }
    }
}
