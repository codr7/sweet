final class Maybe<T>: BaseType<T?>, ValueType {
    let target: BaseType<T> & ValueType
    
    init(_ target: BaseType<T> & ValueType) {
        self.target = target
        var ps = Set(target.parents)
        ps.insert(packages.Core.noneType.typeId)
        super.init("\(target.id)?", Array(ps.map {typeLookup[$0]!}))
    }
}
