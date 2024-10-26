class Package: Sequence {
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
    
    let id: String
    var bindings: Bindings = [:]
    let parent: Package?

    subscript(id: String) -> Value? {
        get {
            return if let value = bindings[id] {
                value
            } else if parent != nil {
                parent![id]
            } else {
                nil
            }
        }
        set(value) { bindings[id] = value }
    }

    init(_ id: String, parent: Package? = nil) {
        self.id = id
        self.parent = parent
    }

    public func makeIterator() -> Iterator {
        Iterator(self)
    }
}
