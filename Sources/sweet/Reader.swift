protocol Reader {
    typealias Output = [Form]

    func read(_ vm: VM,
              _ input: inout Input,
              _ output: inout Output,
              _ location: inout Location) throws -> Bool
}

struct readers {}

final class ReadError: BaseError, @unchecked Sendable {}
