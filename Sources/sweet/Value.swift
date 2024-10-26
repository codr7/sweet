struct Value: Equatable {
    static func == (l: Value, r: Value) -> Bool {
        l.type.equals(r.type) && l.type.equals(l, r)
    }

    let data: Any
    let type: any ValueType

    init<TT, T>(_ type: TT, _ data: T) where TT: BaseType<T>, TT: ValueType {
        self.type = type
        self.data = data
    }

    func cast<T>(_ type: BaseType<T>) -> T { data as! T }
    func dump(_ vm: VM) -> String { type.dump(vm, self) }
    func equals(_ other: Value) -> Bool { type.equals(self, other) }
    func toBit() -> Bit { type.toBit(self) }
}
