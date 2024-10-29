class REPL {
    let vm: VM
    let result: Register
    
    init(_ vm: VM) {
        self.vm = vm
        result = vm.nextRegister
    }
    
    func run() throws  {
        var input = Input()
        var prompt = 1
        var location = Location("repl")
        
        while true {
            print("\(prompt)> ", terminator: "")
            let line = readLine(strippingNewline: false)
            
            if line == nil || line! == "\n" {
                do {     
                    let fs = try vm.read(&input, &location)
                    let startPc = vm.emitPc
                    try fs.emit(vm, result)
                    vm.emit(ops.Stop.make())
                    vm.registers[result] = packages.Core.NIL
                    try vm.eval(startPc)
                    print("\(vm.register(result).dump(vm))\n")
                    input.reset()
                } catch {
                    print("\(error)\n")
                }
                
                prompt = 1
            } else {
                input.append(line!)
                prompt += 1
            }
        }
    }
}
