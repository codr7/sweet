struct Call {
    let target: SweetMethod
    let returnPc: PC
    let result: Register
    let location: Location

    init(_ target: SweetMethod, _ returnPc: PC, _ result: Register, _ location: Location) {
        self.target = target
        self.returnPc = returnPc
        self.result = result
        self.location = location
    }
}
