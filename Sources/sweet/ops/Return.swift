extension ops {
    struct Return {
        static func make() -> Op {
            encode(OpCode.Return)
        }
        
        static func dump(_ vm: VM, _ op: Op) -> String {
            return ""
        }

        static func trace(_ vm: VM, _ op: Op) -> String {
            let c = vm.calls.last!
            let r = c.result
            let t = c.target
            let tr = t.result
            return "target: \(t) result: \(tr)=\(vm.registers[tr].dump(vm)) / \(r)=\(vm.registers[r].dump(vm)) returnPc: \(c.returnPc)"
        }
    }
}
