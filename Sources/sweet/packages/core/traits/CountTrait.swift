extension packages.Core {
    protocol CountTrait {
        typealias Count = (_ target: Value) -> Int
        var count: Count? {get}
    }
}
