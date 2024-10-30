typealias List = [Value]

extension List {
    func dump(_ vm: VM) -> String { "[\(map({$0.dump(vm)}).joined(separator: " "))]" }
}

func ==(l: List, r: List) -> Bool {
    if l.count != r.count { return false }

    for i in 0..<min(l.count, r.count) {
        if l[i] != r[i] { return false; }
    }

    return true
}
