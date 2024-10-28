class Package: CustomStringConvertible, Sequence {
    static func == (l: Package, r: Package) -> Bool { l.id == r.id }
    
    typealias Bindings = [String:Value]
    
    struct Iterator: IteratorProtocol {
        var package: Package
        var iterator: Bindings.Iterator
        
        init(_ package: Package) {
            self.package = package
            iterator = package.bindings.makeIterator()
        }
        
        mutating func next() -> (String, Value)? {
            if let next = iterator.next() { return next }
            if package.parent == nil { return nil }
            package = package.parent!
            iterator = package.bindings.makeIterator()
            return next()
        }
    }

    var description: String {id}
    let id: String
    var bindings: Bindings = [:]
    let parent: Package?

    subscript(id: String) -> Value? {
        get {
            return
              if let value = bindings[id] {value}
              else if parent != nil {parent![id]}
              else {nil}
        }
        
        set(value) {bindings[id] = value}
    }

    init(_ id: String, parent: Package? = nil) {
        self.id = id
        self.parent = parent
    }

    func setup(_ vm: VM) {}

    func bind(_ value: Macro) {
        self[value.id] = Value(packages.Core.macroType, value)
    }

    func bind(_ value: Package) {
        self[value.id] = Value(packages.Core.packageType, value)
    }

    func bind(_ value: ValueType) {
        self[value.id] = Value(packages.Core.metaType, value)
    }

    func bindMacro(_ id: String, _ arguments: [String], _ body: @escaping Macro.Body) {
        self[id] = Value(packages.Core.macroType, Macro(id, arguments, body))
    }

    var ids: [String] { Array(bindings.keys) }
    
    func importFrom(_ source: Package, _ ids: [String]) {
        for id in ids { bindings[id] = source[id] }
    }
      
    func makeIterator() -> Iterator { Iterator(self) }
}

struct packages {}
