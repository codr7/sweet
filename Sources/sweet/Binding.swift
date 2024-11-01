struct Binding {
    static func ==(l: Binding, r: Binding) -> Bool { l.register == r.register }
    let register: Register
    var type: ValueType? = nil
    init(_ register: Register) { self.register = register }
}
