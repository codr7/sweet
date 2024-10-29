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
        for a in target.sweetArguments { frame.append((a.target, vm.registers[a.target])) }
        if target.options.resultType != nil { frame.append((result, vm.registers[result])) }
    }
}
