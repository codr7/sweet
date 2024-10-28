let vm = VM()

vm.user.bind(vm.core)
vm.user.bind(vm.user)
vm.user.importFrom(vm.core, vm.core.ids)

try REPL(vm).run()
