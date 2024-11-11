struct Call {
    let target: SweetMethod
    let returnPc: PC
    let result: Register
    let location: Location
    var frame: [(Register, Value)] = []

    init(_ vm: VM,
         _ target: SweetMethod,
         _ returnPc: PC,
         _ result: Register,
         _ location: Location) {
        self.target = target
        self.returnPc = returnPc
        self.result = result
        self.location = location

        for a in target.sweetArguments {
            if !a.id.isNone { frame.append((a.target, vm.registers[a.target])) }
        }
    }

    init(_ vm: VM,
         _ source: Call,
         _ target: SweetMethod,
         _ location: Location) {
        self.target = target
        self.returnPc = source.returnPc
        self.result = source.result
        self.location = location
        frame = source.frame
    }
}
