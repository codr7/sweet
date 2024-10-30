class List {
    typealias Items = [Value]

    static func ==(l: List, r: List) -> Bool {
        if l.items.count != r.items.count { return false }

        for i in 0..<min(l.items.count, r.items.count) {
            if l.items[i] != r.items[i] { return false; }
        }

        return true
    }

    var items: Items

    init(repeating: Value, count: Int) {
        items = Array(repeating: repeating, count: count)
    }
    
    func dump(_ vm: VM) -> String { "[\(items.map({$0.dump(vm)}).joined(separator: " "))]" }
}
