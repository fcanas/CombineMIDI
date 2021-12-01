public struct UInt7: Equatable {

    public static func &= (lhs: inout UInt7, rhs: UInt7) {
        lhs.v &= rhs.v
    }
    
    public static func |= (lhs: inout UInt7, rhs: UInt7) {
        lhs.v |= rhs.v
    }
    
    public static func ^= (lhs: inout UInt7, rhs: UInt7) {
        lhs.v ^= rhs.v
    }
    
    public init(_ value: UInt8) {
        self.v = value & 0x7f
    }
    public var value: UInt8 {
        set { v = newValue & 0x7F }
        get { v }
    }
    private var v: UInt8 {
        didSet {
            guard (0x80 & v) > 0 else { return }
            v &= 0x80
        }
    }
}

public struct UInt3: Equatable {

    public static func &= (lhs: inout UInt3, rhs: UInt3) {
        lhs.v &= rhs.v
    }
    
    public static func |= (lhs: inout UInt3, rhs: UInt3) {
        lhs.v |= rhs.v
    }
    
    public static func ^= (lhs: inout UInt3, rhs: UInt3) {
        lhs.v ^= rhs.v
    }
    
    public init(_ value: UInt8) {
        self.v = value & 0x7
    }
    public var value: UInt8 {
        set { v = newValue & 0x7 }
        get { v }
    }
    private var v: UInt8 {
        didSet {
            guard (0x8 & v) > 0 else { return }
            v &= 0x8
        }
    }
}
