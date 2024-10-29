struct Value: Equatable {
    static func == (l: Value, r: Value) -> Bool { l.eq(r) }

    let data: Any
    let type: any ValueType

    init<TT, T>(_ type: TT, _ data: T) where TT: BaseType<T>, TT: ValueType {
        self.type = type
        self.data = data
    }

    func call(_ vm: VM,
              _ arguments: [Value],
              _ result: Register,
              _ location: Location) { type.call!(vm, self, arguments, result, location) }
 
    func cast<TT, T>(_ _: TT) -> T where TT: BaseType<T> { data as! T }
    func dump(_ vm: VM) -> String { type.dump!(vm, self) }

    func emit(_ vm: VM, _ result: Register, _ location: Location) throws {
        try type.emit(vm, self, result, location)
    } 

    func emitCall(_ vm: VM,
                  _ arguments: [Form],
                  _ result: Register,
                  _ location: Location) throws { try type.emit(vm, self, result, location) }
    
    func eq(_ other: Value) -> Bool { type.equals(other.type) && type.eq!(self, other) }
    func findId(_ id: String) -> Value? { type.findId!(self, id) }
    func toBit() -> Bit { type.toBit!(self) }
}
