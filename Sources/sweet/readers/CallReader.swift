extension readers {
    struct Call: Reader {
        static let instance = Call()
        
        func read(_ vm: VM,
                  _ input: inout Input,
                  _ output: inout Output,
                  _ location: inout Location) throws -> Bool {
            let startLocation = location
            if input.peekChar() != "(" { return false }
            input.dropChar()
            location.column += 1
            var arguments: [Form] = []
            
            while true {
                Whitespace.instance.read(vm, &input, &output, &location)
                
                if input.peekChar() == ")" {
                    input.dropChar()
                    location.column += 1
                    break
                }
                
                if (!(try vm.read(&input, &arguments, &location))) {
                    throw ReadError("Unexpected end of call", location)
                }
            }
            
            output.append(forms.Call(arguments, startLocation))
            return true
        }
    }
}
