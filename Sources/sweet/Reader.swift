protocol Reader {
    typealias Output = [Form]

    func read(_ input: inout Input,
              _ output: inout Output,
              _ location: inout Location) -> Bool
}

struct readers {}

class ReadError: BaseError {}
