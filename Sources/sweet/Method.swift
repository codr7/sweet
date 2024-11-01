protocol Method {
    var id: String {get}

    var isConst: Bool {get}
    var isVararg: Bool {get}
    var resultType: ValueType? {get}
    
    func call(_ vm: VM,
	      _ arguments: [Value],
	      _ result: Register,
	      _ location: Location) throws
}
