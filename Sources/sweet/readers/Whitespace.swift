extension readers {
    struct Whitespace: Reader {
        static let instance = Whitespace()
        
        @discardableResult
        func read(_ input: inout Input,
                  _ output: inout Output,
                  _ location: inout Location) -> Bool {
            let startLocation = location;
            
            while let c = input.popChar() {
                if c.isNewline {
                    location.nextLine()
                } else if c.isWhitespace {
                    location.column += 1
                } else {
                    input.pushChar(c)
                    break
                }
            }
            
            return location != startLocation
        }
    }
}
