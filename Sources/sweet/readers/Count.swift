extension readers {
    struct Count: Reader {
        static let instance = Count()
        
        func read(_ vm: VM,
                  _ input: inout Input,
                  _ output: inout Output,
                  _ location: inout Location) throws -> Bool {
            if input.peekChar() != "#" { return false }
            let startLocation = location
            input.dropChar()
            location.column += 1

            if !(try vm.read(&input, &output, &location)) {
                throw ReadError("Invalid count", location)
            }

            let t = output.removeLast()

            output.append(forms.Call([forms.Id("core/count", startLocation), t],
                                     startLocation))

            return true
        }
    }
}
