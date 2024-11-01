extension readers {
    struct Pair: Reader {
        static let instance = Pair()
        
        func read(_ vm: VM,
                  _ input: inout Input,
                  _ output: inout Output,
                  _ location: inout Location) throws -> Bool {
            Whitespace.instance.read(vm, &input, &output, &location)
            if output.isEmpty || input.peekChar() != ":" { return false }
            let startLocation = location
            input.dropChar()
            location.column += 1
            let left = output.removeLast()

            if !(try vm.read(&input, &output, &location)) {
                throw ReadError("Invalid pair", location)
            }

            Whitespace.instance.read(vm, &input, &output, &location)
            
            if input.peekChar() == ":" {
                let ok = try vm.read(&input, &output, &location)

                if !ok || output.isEmpty {
                    throw ReadError("Invalid nested pair", location)
                }
            }
            
            let right = output.removeLast()
            output.append(forms.Pair(left, right, startLocation))
            return true
        }
    }
}
