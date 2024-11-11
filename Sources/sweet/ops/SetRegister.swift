extension ops {
    struct SetRegister {
        static let targetStart = opCodeWidth
        static let targetWidth = registerWidth
        static let valueStart = targetStart + targetWidth
        static let valueWidth = tagWidth

        static func target(_ op: Op) -> Register { decodeRegister(op, targetStart) }
        static func value(_ op: Op) -> Tag { decodeTag(op, valueStart) }
        
        static func make(_ vm: VM, _ target: Register, _ value: Value) -> Op {
            if value == packages.Core.NONE { return ClearRegister.make(target) }
            
            return encode(OpCode.SetRegister) +
              encodeRegister(target, targetStart) +
              encodeTag(vm.tag(value), valueStart); 
        }

        static func dump(_ vm: VM, _ op: Op) -> String {
            let t = target(op)
            return "target: \(t) value: \((vm.tags[value(op)] as! Value).dump(vm))"
        }

        static func trace(_ vm: VM, _ op: Op) -> String {
            let t = target(op)
            return "target: \(t)=\(vm.registers[t].say(vm)) value: \((vm.tags[value(op)] as! Value).dump(vm))"
        }
    }
}
