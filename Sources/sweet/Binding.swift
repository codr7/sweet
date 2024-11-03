struct Binding {
    static func ==(l: Binding, r: Binding) -> Bool { l.register == r.register }
    let register: Register
    var type: ValueType?
    
    init(_ register: Register, _ type: ValueType? = nil) {
        self.register = register
        self.type = type
    }
}
