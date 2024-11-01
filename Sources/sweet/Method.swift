protocol Method {
    var id: String {get}
    var options: BaseMethod.Options {get}
    
    func call(_ vm: VM,
	      _ arguments: [Value],
	      _ result: Register,
	      _ location: Location) throws
}
