import SystemPackage

func load(_ vm: VM, _ offset: Int) throws {
    for p in CommandLine.arguments[offset...] { try vm.load(FilePath(p), result) }
}

let vm = VM()

vm.user.bind(vm.core)
vm.user.bind(vm.user)
let result = vm.nextRegister

if CommandLine.arguments.count == 1 {
    vm.user.importFrom(vm.core, vm.core.ids)
    try REPL(vm).run()
} else {
    vm.user.importFrom(vm.core, ["import!"])
    let startPc = vm.emitPc

    switch CommandLine.arguments[1] {
    case "dump":
        try load(vm, 2)
        
        for i in startPc..<vm.emitPc {
            let op = vm.code[i]
            print("\(i) \(ops.decode(op)) \(ops.dump(vm, op))")
        }
    default:
        try load(vm, 1)
        vm.emit(ops.Stop.make())
        try vm.eval(startPc)
    }
}
