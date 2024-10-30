extension readers {
    struct List: Reader {
        static let instance = List()
        
        func read(_ vm: VM,
                  _ input: inout Input,
                  _ output: inout Output,
                  _ location: inout Location) throws -> Bool {
            let startLocation = location
            if input.peekChar() != "[" { return false }
            input.dropChar()
            location.column += 1
            var items: [Form] = []
            
            while true {
                Whitespace.instance.read(vm, &input, &output, &location)
                
                if input.peekChar() == "]" {
                    input.dropChar()
                    location.column += 1
                    break
                }
                
                if (!(try vm.read(&input, &items, &location))) {
                    throw ReadError("Unexpected end of list", location)
                }
            }
            
            output.append(forms.List(items, startLocation))
            return true
        }
    }
}
