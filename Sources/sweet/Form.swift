protocol Form {
    var location: Location {get}
    func dump(_ vm: VM) -> String
    func emit(_ vm: VM, _ result: Register) throws(EmitError)
    func getValue(_ vm: VM) -> Value?
}

class BaseForm {
    let location: Location
    init(_ location: Location) { self.location = location }
    func getValue(_ vm: VM) -> Value? { nil }
}

class EmitError: BaseError {}

struct forms {}
