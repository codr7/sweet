extension String {
    var isAny: Bool { self == "@" } 
    var isNone: Bool { self == "_" } 
    var isSeparator: Bool { self == ";" } 
}
