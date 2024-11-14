extension forms {
    class List: BaseForm, Form {
        let items: [Form]
        
        init(_ items: [Form], _ location: Location) {
            self.items = items
            super.init(location)
        }

        func dump(_ vm: VM) -> String {
            "[\(items.map({"\($0.dump(vm))"}).joined(separator: " "))]"
        }
        
        func emit(_ vm: VM, _ result: Register) throws {
            vm.emit(ops.InitList.make(result, items.count))
            let ir = vm.nextRegister
            
            for i in 0..<items.count {
                try items[i].emit(vm, ir)
                vm.emit(ops.SetItem.make(result, i, ir))
            }
        }

        func getIds(_ ids: inout Set<String>) {
            for f in items { f.getIds(&ids) }
        }

        override func getType(_ vm: VM) -> ValueType? { packages.Core.listType }
    }
}
