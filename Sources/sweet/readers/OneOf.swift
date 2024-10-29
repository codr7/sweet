extension readers {
    struct OneOf: Reader {
        let members: [Reader]

        init(_ members: Reader...) { self.members = members }

        func read(_ vm: VM,
                  _ input: inout Input,
                  _ output: inout Output,
                  _ location: inout Location) throws -> Bool {
            try members.contains { try $0.read(vm, &input, &output, &location) }
        }
    }
}
