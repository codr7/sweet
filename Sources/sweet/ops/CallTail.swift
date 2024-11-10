extension ops {
    struct CallTail {
        static let targetStart = opCodeWidth
        static let targetWidth = tagWidth

        static let arityStart = targetStart + targetWidth
        static let arityWidth: UInt8 = 8

        static let locationStart = arityStart + arityWidth
        static let locationWidth = tagWidth
        
        static func target(_ op: Op) -> Tag { decodeTag(op, targetStart) }
        static func arity(_ op: Op) -> Int { Int(decode(op, arityStart, arityWidth)) }
        static func location(_ op: Op) -> Tag { decodeTag(op, locationStart) }
        
        static func make(_ vm: VM,
                         _ target: SweetMethod,
                         _ arity: Int,
                         _ location: Location) -> Op {
            let tt = vm.tag(target)
            let lt = vm.tag(location)
            
            return encode(OpCode.CallTail) +
              encodeTag(tt, targetStart) +
              encode(arity, arityStart, arityWidth) +
              encodeTag(lt, locationStart); 
        }

        static func dump(_ vm: VM, _ op: Op) -> String {
            let t = target(op)
            let m = vm.tags[t] as! SweetMethod
            let a0 = m.arguments.isEmpty ? 0 : m.sweetArguments[0].target
            let arguments = a0..<a0+arity(op)
            return "target: \(t)=\(m) arguments: [\(arguments.map({"\($0)"}).joined(separator: " "))]"
        }

        static func trace(_ vm: VM, _ op: Op) -> String {
            let t = target(op)
            let m = vm.tags[t] as! SweetMethod
            let a0 = m.arguments.isEmpty ? 0 : m.sweetArguments[0].target
            let arguments = a0..<a0+arity(op)
            return "target: \(t)=\(vm.tags[t] as! SweetMethod) arguments: [\(arguments.map({"\($0)=\(vm.registers[$0].dump(vm))"}).joined(separator: " "))]"
        }
    }
}
