var nextTypeId: TypeId = 0

class BaseType<T> {    
    typealias Data = T

    static func == (l: BaseType<T>, r: BaseType<T>) -> Bool {
        l.id == r.id
    }

    lazy var hierarchy: Set<TypeId> = {
        var result: Set<TypeId> = [typeId]
        for pt in parents { result.formUnion(pt.hierarchy) }
        return result
    }()

    let id: String
    let parents: [any ValueType]
    let typeId: TypeId
    
    init(_ id: String, _ parents: [any ValueType] = []) {
        self.id = id
        self.parents = parents
        self.typeId = nextTypeId
        nextTypeId += 1
    }

}
