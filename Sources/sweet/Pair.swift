typealias Pair = (Value, Value)

func dump(_ vm: VM, _ value: Pair) -> String { "\(value.0.dump(vm)):\(value.1.dump(vm))" }
