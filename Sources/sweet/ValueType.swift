protocol ValueType {
    func dump(_ vm: VM, _ value: Value) -> String
}

extension ValueType {
    func dump(_ vm: VM, _ value: Value) -> String {
        "\(value.data)"        
    }
}
