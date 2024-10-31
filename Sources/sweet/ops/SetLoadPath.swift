import SystemPackage

extension ops {
    struct SetLoadPath {
        static let pathStart = opCodeWidth
        static let pathWidth = tagWidth

        static func path(_ op: Op) -> Tag { decodeTag(op, pathStart) }
        
        static func make(_ vm: VM, _ path: FilePath) -> Op {
            let pt = vm.tag(path)
            return encode(OpCode.SetLoadPath) + encodeTag(pt, pathStart); 
        }
    }
}
