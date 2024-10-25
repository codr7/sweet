struct Value {
    let data: Any
    let type: ValueType
    
    func dump(_ vm: VM) -> String { type.dump(vm, self) }
}
