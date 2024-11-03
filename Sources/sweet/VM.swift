import Foundation
import SystemPackage

extension FileHandle {
    func readAll() throws -> String {
        let d = try readToEnd()!
        return String(decoding: d, as: UTF8.self)
    }
}

class VM {
    var calls: [Call] = []
    var code: [Op] = []
    var loadPath: FilePath = ""
    
    let reader = readers.OneOf(
      readers.Whitespace.instance,
      readers.IntReader.instance,
      readers.Call.instance,
      readers.Count.instance,
      readers.Id.instance,
      readers.List.instance,
      readers.Pair.instance,
      readers.Splat.instance,
      readers.String.instance
    )
    
    var pc: PC = 0
    var registers: [Value] = []
    var tags: [Any] = []

    let core = packages.Core("core")
    var user = Package("user")
    var currentPackage: Package
    
    init() {
        currentPackage = user
        core.initBindings(self)
        user.initBindings(self)
    }

    func doPackage<T>(_ bodyPackage: Package?, _ body: () throws -> T) throws -> T {
        let pp = currentPackage
        currentPackage = bodyPackage ?? Package(currentPackage.id, currentPackage)
        defer { currentPackage = pp }
        return try body()
    }
    
    @discardableResult
    func emit(_ op: Op) -> PC {
        let result = emitPc
        code.append(op)
        return result
    }

    var emitPc: PC { code.count }

    func endCall() -> Call { calls.removeLast() }

    func load(_ path: FilePath, _ result: Register) throws {
        let prevLoadPath = vm.loadPath
        let p = vm.loadPath.appending("\(path)")
        vm.loadPath.append("\(path.removingLastComponent())")
        defer { vm.loadPath = prevLoadPath }
        let fh = FileHandle(forReadingAtPath: "\(p)")!
        defer { try! fh.close() }
        var input = Input(try fh.readAll())
        var location = Location("\(p)")
        let fs = try read(&input, &location)
        vm.emit(ops.SetLoadPath.make(self, p))
        try fs.emit(self, result)
        vm.emit(ops.SetLoadPath.make(self, prevLoadPath))
    }
    
    var nextRegister: Register {
        let result = registers.count
        registers.append(packages.Core.NONE)
        return Register(result)
    }

    func nextRegisters(_ n: Int) -> Register {
        let result = nextRegister
        registers += Array(repeating: packages.Core.NONE, count: n)
        return result
    }

    func maybe<T>(_ target: BaseType<T> & ValueType) -> ValueType {
        if let v = currentPackage["\(target.id)?"] { return v.cast(packages.Core.metaType) }
        let t = Maybe<T>(target)
        currentPackage.bind(t)
        return t
    }
    
    func read(_ input: inout Input,
              _ output: inout [Form],
              _ location: inout Location) throws -> Bool {
        try reader.read(self, &input, &output, &location)
    }

    func read(_ input: inout Input, _ location: inout Location) throws -> [Form] {
        var result: [Form] = []
        while try read(&input, &result, &location) {}
        return result
    }

    func tag(_ value: Any) -> Tag {
        let result = tags.count
        tags.append(value)
        return result
    }
}
