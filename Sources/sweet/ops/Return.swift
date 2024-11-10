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
            return "target: \(c.target) result: \(c.result)=\(vm.registers[c.result].dump(vm)) returnPc: \(c.returnPc)"
        }
    }
}
