extension readers {
    struct Splat: Reader {
        static let instance = Splat()
        
        func read(_ vm: VM,
                  _ input: inout Input,
                  _ output: inout Output,
                  _ location: inout Location) throws -> Bool {
            if input.peekChar() != "*" || output.isEmpty { return false }
            let startLocation = location
            input.dropChar()
            location.column += 1
            let t = output.removeLast()
            output.append(forms.Splat(t, startLocation))
            return true
        }
    }
}
