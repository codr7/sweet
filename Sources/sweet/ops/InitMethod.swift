extension ops {
    struct InitMethod {
        static let targetStart = opCodeWidth
        static let targetWidth = tagWidth
        static let skipStart = targetStart + targetWidth
        static let skipWidth = pcWidth

        static func target(_ op: Op) -> Tag { decodeTag(op, targetStart) }
        static func skip(_ op: Op) -> PC { decodePc(op, skipStart) }
        
        static func make(_ vm: VM, _ target: Value, _ skip: PC) -> Op {
            let tt = vm.tag(target)
            
            return encode(OpCode.InitMethod) +
              encodeTag(tt, targetStart) +
              encodePc(skip, skipStart); 
        }
    }
}
