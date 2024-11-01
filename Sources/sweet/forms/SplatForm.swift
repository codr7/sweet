extension forms {
    class Splat: BaseForm, Form {
        let target: Form
        
        init(_ target: Form, _ location: Location) {
            self.target = target
            super.init(location)
        }

        func dump(_ vm: VM) -> String { "\(target.dump(vm))*" }
        
        func emit(_ vm: VM, _ result: Register) throws {
            throw EmitError("Not supported", location)
        }

        func getConstViolation(_ vm: VM) -> Form? {
            target.getConstViolation(vm)
        }
    }
}
