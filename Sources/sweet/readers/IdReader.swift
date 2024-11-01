extension readers {
    struct Id: Reader {
        static let instance = Id()
        
        func read(_ vm: VM,
                  _ input: inout Input,
                  _ output: inout Output,
                  _ location: inout Location) -> Bool {
            let startLocation = location
            var result = ""
            
            while let c = input.popChar() {
                if c.isWhitespace ||
                     c == "(" || c == ")" ||
                     c == "[" || c == "]" ||
                     (c == ";" && !result.isEmpty) {
                    input.pushChar(c)
                    break
                }

                result.append(c)
                location.column += 1
                if c == "^" || c == ";" {break}
            }
            
            if result == "" { return false }
            output.append(forms.Id(result, startLocation))
            return true
        }
    }
}
