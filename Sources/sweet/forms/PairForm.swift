extension forms {
    class Pair: BaseForm, Form {
        let left: Form
        let right: Form
        
        init(_ left: Form, _ right: Form, _ location: Location) {
            self.left = left
            self.right = right
            super.init(location)
        }

        func dump(_ vm: VM) -> String { "\(left.dump(vm)):\(right.dump(vm))" }
        
        func emit(_ vm: VM, _ result: Register) throws {
            let lr = result
            try left.emit(vm, lr)
            let rr = vm.nextRegister
            try right.emit(vm, rr)
            vm.emit(ops.Zip.make(lr, rr, result))
        }

        func getConstViolation(_ vm: VM) -> Form? {
            left.getConstViolation(vm) ?? right.getConstViolation(vm)
        }

        func getIds(_ ids: inout Set<String>) {
            left.getIds(&ids)
            right.getIds(&ids)
        }
    }
}
