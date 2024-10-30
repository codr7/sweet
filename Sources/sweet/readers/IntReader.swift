extension readers {
    struct IntReader: Reader {
        static let instance = IntReader()

        static let charValues: [Character:Int] = [
          "0":0, "1":1, "2":2, "3":3, "4":4, "5":5, "6":6, "7":7,
          "8":8, "9":9, "a":10, "b":11, "c":12, "d":13, "e":14,
          "f":15
        ]

        func read(_ input: inout Input,
                  _ base: Int,
                  _ location: inout Location) -> Int {
            var result = 0
            
            while let c = input.popChar() {
                if !c.isNumber { break }
                result = result * base + IntReader.charValues[c]!
                location.column += 1
            }

            return result
        }
        
        func read(_ vm: VM,
                  _ input: inout Input,
                  _ output: inout Output,
                  _ location: inout Location) -> Bool {
            let c = input.peekChar()
            if c == nil || !c!.isNumber { return false }
            let startLocation = location
            let v = read(&input, 10, &location)
            output.append(forms.Literal(Value(packages.Core.intType, v), startLocation))
            return true
        }
    }
}
