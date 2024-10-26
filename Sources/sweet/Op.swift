typealias Op = UInt128;

var opCodeCount = 0
var opCodes: [UInt8:OpCode] = [:]

struct OpCode: OptionSet {
    let id: String
    let rawValue: UInt8

    static let setRegister = OpCode("SetRegister")
    static let stop = OpCode("Stop")

    static func find(_ rawValue: UInt8) -> OpCode? { opCodes[rawValue] }
    
    init(_ id: String) {
        self.id = id
        rawValue = 1 << opCodeCount
        opCodeCount += 1
        opCodes[rawValue] = self
    }
    
    init(rawValue: UInt8) { fatalError("Not supported") }
}
