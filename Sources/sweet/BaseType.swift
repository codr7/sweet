var nextTypeId: TypeId = 0
var typeLookup: [TypeId:ValueType] = [:]

class BaseType<T> {    
    typealias Data = T

    static func == (l: BaseType<T>, r: BaseType<T>) -> Bool { l.id == r.id }   
    static func findId(_ id: TypeId) -> ValueType? { typeLookup[id] }

    var eq: ValueType.Eq? = nil
    var toBit: ValueType.ToBit? = nil

    lazy var parents: [any ValueType] = {
        var result: Set<TypeId> = [typeId]
        for pt in _parents { result.formUnion(pt.parents.map({$0.typeId})) }
        let ps = Array(result.map({BaseType<T>.findId($0)!}))
        let wps = ps.sorted(by:{$0.parents.count > $1.parents.count})
 
        for pt in wps {
            dump = dump ?? pt.dump
            eq = eq ?? pt.eq
            toBit = toBit ?? pt.toBit
        }
        
        return ps
    }()

    let id: String
    let _parents: [any ValueType]
    let typeId: TypeId
    var dump: ValueType.Dump? = {(_ vm: VM, _ value: Value) -> String in "\(value.data)" }
    
    init(_ id: String, _ parents: [any ValueType] = []) {
        self.id = id
        self._parents = parents
        self.typeId = nextTypeId
        nextTypeId += 1
    }
}
