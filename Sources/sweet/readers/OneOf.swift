extension readers {
    struct OneOf: Reader {
        let members: [Reader]

        init(_ members: Reader...) { self.members = members }

        func read(_ input: inout Input,
                  _ output: inout Output,
                  _ location: inout Location) -> Bool {
            members.contains { $0.read(&input, &output, &location) }
        }
    }
}
