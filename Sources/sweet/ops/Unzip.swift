extension ops {
    struct Unzip {
        static let targetStart = opCodeWidth
        static let targetWidth = registerWidth

        static let leftFlag = targetStart + targetWidth
        static let leftStart = leftFlag + 1
        static let leftWidth = registerWidth

        static let rightFlag = leftStart + leftWidth
        static let rightStart = leftFlag + 1
        static let rightWidth = registerWidth

        static func target(_ op: Op) -> Register { decodeRegister(op, targetStart) }

        static func left(_ op: Op) -> Register? {
            decodeFlag(op, leftFlag) ? decodeRegister(op, leftStart) : nil
        }
        
        static func right(_ op: Op) -> Register? {
            decodeFlag(op, rightFlag) ? decodeRegister(op, rightStart) : nil
        }
        
        static func make(_ target: Register, _ left: Register?, _ right: Register?) -> Op {
            encode(OpCode.Unzip) +
              encodeRegister(target, targetStart) +
              encodeFlag(left != nil, leftFlag) +
              ((left == nil) ? 0 : encodeRegister(left!, leftStart)) +
              encodeFlag(right != nil, rightFlag) +
              ((right == nil) ? 0 : encodeRegister(right!, rightStart));
        }
    }
}
