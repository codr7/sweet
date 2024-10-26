typealias Op = UInt128;
typealias PC = UInt32;
typealias Register = UInt32;

struct packages {
}

class VM {    
    var code: [Op] = []
    var registers: [Value] = []

    let core = packages.Core("core");

    init() {}
    
    func emit(_ op: Op) -> PC {
        let result = emit_pc
        code.append(op)
        return result
    }

    var emit_pc: PC { get {PC(code.count)} }

    var next_register: Register {
        let result = registers.count
        registers.append(core.NIL)
        return Register(result)
    }
}
