extension ops {
    struct CallTail {
        static let targetStart = opCodeWidth
        static let targetWidth = tagWidth

        static let argumentStart = targetStart + targetWidth
        static let argumentWidth = registerWidth

        static let arityStart = argumentStart + argumentWidth
        static let arityWidth: UInt8 = 8

        static let locationStart = arityStart + arityWidth
        static let locationWidth = tagWidth
        
        static func target(_ op: Op) -> Tag { decodeTag(op, targetStart) }
        static func argument(_ op: Op) -> Register { decodeRegister(op, argumentStart) }
        static func arity(_ op: Op) -> Int { Int(decode(op, arityStart, arityWidth)) }
        static func location(_ op: Op) -> Tag { decodeTag(op, locationStart) }
        
        static func make(_ vm: VM,
                         _ target: SweetMethod,
                         _ argument: Register,
                         _ arity: Int,
                         _ location: Location) -> Op {
            let tt = vm.tag(target)
            let lt = vm.tag(location)
            
            return encode(OpCode.CallTail) +
              encodeTag(tt, targetStart) +
              encodeRegister(argument, argumentStart) +
              encode(arity, arityStart, arityWidth) +
              encodeTag(lt, locationStart); 
        }

        static func dump(_ vm: VM, _ op: Op) -> String {
            let t = target(op)
            let a0 = argument(op)
            let arguments = a0..<a0+arity(op)
            return "target: \(t)=\(vm.tags[t] as! SweetMethod) arguments: [\(arguments.map({"\($0)=\(vm.registers[$0].dump(vm))"}).joined(separator: " "))]"
        }
    }
}
