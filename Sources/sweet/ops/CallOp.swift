extension ops {
    struct Call {
        static let targetStart = opCodeWidth
        static let targetWidth = registerWidth

        static let argumentStart = targetStart + targetWidth
        static let argumentWidth = registerWidth

        static let arityStart = argumentStart + argumentWidth
        static let arityWidth: UInt8 = 8

        static let resultStart = arityStart + arityWidth
        static let resultWidth = registerWidth

        static let locationStart = resultStart + resultWidth
        static let locationWidth = tagWidth
        
        static func target(_ op: Op) -> Register { decodeRegister(op, targetStart) }
        static func argument(_ op: Op) -> Register { decodeRegister(op, argumentStart) }
        static func arity(_ op: Op) -> Int { Int(decode(op, arityStart, arityWidth)) }
        static func result(_ op: Op) -> Register { decodeRegister(op, resultStart) }
        static func location(_ op: Op) -> Tag { decodeTag(op, locationStart) }
        
        static func make(_ vm: VM,
                         _ target: Register,
                         _ argument: Register,
                         _ arity: Int,
                         _ result: Register,
                         _ location: Location) -> Op {
            let lt = vm.tag(location)
            
            return encode(OpCode.Call) +
              encodeRegister(target, targetStart) +
              encodeRegister(argument, argumentStart) +
              encode(arity, arityStart, arityWidth) +
              encodeRegister(result, resultStart) +
              encodeTag(lt, locationStart); 
        }

        static func dump(_ vm: VM, _ op: Op) -> String {
            let t = target(op)
            let a0 = argument(op)
            let arguments = a0..<a0+arity(op)
            let r = result(op)
            return "target: \(t)=\(vm.registers[t].dump(vm)) arguments: [\(arguments.map({"\($0)=\(vm.registers[$0].dump(vm))"}).joined(separator: " "))] result: \(r)=\(vm.registers[r].dump(vm))"
        }
    }
}
