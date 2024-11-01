import SystemPackage

let vm = VM()

vm.user.bind(vm.core)
vm.user.bind(vm.user)

if CommandLine.arguments.count == 1 {
    vm.user.importFrom(vm.core, vm.core.ids)
    try REPL(vm).run()
} else {
    vm.user.importFrom(vm.core, ["import!"])
    let result = vm.nextRegister
    let startPc = vm.emitPc
    for p in CommandLine.arguments[1...] { try vm.load(FilePath(p), result) }
    vm.emit(ops.Stop.make())
    try vm.eval(startPc)
}
