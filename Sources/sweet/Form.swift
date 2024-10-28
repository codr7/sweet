protocol Form: CustomStringConvertible {
    var location: Location {get}
    func cast<T>(_ type: T.Type) -> T?
    func dump() -> String
    func emit(_ vm: VM, _ result: Register) throws(EmitError)
    func getValue(_ vm: VM) -> Value?
}

extension Form {
    var description: String { dump() }
}

class BaseForm {
    let location: Location
    init(_ location: Location) { self.location = location }
    func cast<T>(_ type: T.Type) -> T? {self as? T}
    func getValue(_ vm: VM) -> Value? { nil }
}

extension [Form] {
    func emit(_ vm: VM, _ result: Register) throws(EmitError) {
        for f in self { try f.emit(vm, result) }
    }
}

class EmitError: BaseError {}

struct forms {}
