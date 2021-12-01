/// Typed MIDI message interpretation.
public enum MIDIMessage {
    
    public struct Note {
        public var channel: UInt8
        public var noteNumber: UInt8
        public var velocity: UInt8
    }
    
    public struct PolyphonicAftertouch {
        public var channel: UInt8
        public var noteNumber: UInt8
        public var pressure: UInt8
    }
    
    public struct ProgramChange {
        public var channel: UInt8
        public var program: UInt8
    }
    
    public struct ChannelAftertouch {
        public var channel: UInt8
        public var pressureValue: UInt8
    }
    
    public struct PitchBend {
        public var channel: UInt8
        public var lsb: UInt8
        public var msb: UInt8
    }
    
    public struct ControlChange {
        public var channel: UInt8
        public var control: UInt7
        public var controlValue: UInt8
    }
    
    case noteOff(Note)
    case noteOn(Note)
    case afterTouch(PolyphonicAftertouch)
    case controlChange(ControlChange)
    case programChange(ProgramChange)
    case channelPressure(ChannelAftertouch)
    case pitchBendChange(PitchBend)
    case tuneRequest
    case timingClock
    case start
    case stop
    case `continue`
    case activeSensing
    case systemReset
    
    /// Kind of the message.
    public enum Status: UInt8 {
        /// Note Off event.
        /// This message is sent when a note is released (ended).
        case noteOff = 0x80

        /// Note On event.
        /// This message is sent when a note is depressed (start).
        case noteOn = 0x90

        /// Polyphonic Key Pressure (Aftertouch).
        /// This message is most often sent by pressing down on
        /// the key after it "bottoms out".
        case aftertouch = 0xA0

        /// Control Change. This message is sent when a controller
        /// value changes. Controllers include devices such as
        /// pedals and levers.
        case controlChange = 0xB0

        /// Program Change. This message sent when the patch
        /// number changes.
        case programChange = 0xC0

        /// Channel Pressure (After-touch).
        /// This message is most often sent by pressing down on
        /// the key after it "bottoms out". This message is
        /// different from polyphonic after-touch. Use this
        /// message to send the single greatest pressure value
        /// (of all the current depressed keys).
        case channelPressure = 0xD0

        /// Pitch Bend Change. This message is sent to indicate
        /// a change in the pitch bender (wheel or lever, typically).
        /// The pitch bender is measured by a fourteen bit value.
        case pitchBendChange = 0xE0
        
        case tuneRequest = 0xF6
        case timingClock = 0xF8
        case start = 0xFA
        case `continue` = 0xFB
        case stop = 0xFC
        case activeSensing = 0xFE
        case systemReset = 0xFF
    }

    /// All Notes Off. When an All Notes Off is received, all oscillators will turn off.
    static let allNotesOff: MIDIMessage = .controlChange(ControlChange(channel: 0, control: 123, controlValue: 0))
        

    /// Initializes new message manually with all the parameters.
    /// - Parameters:
    ///   - status: Kind of the message.
    ///   - channel: Channel of the message. Between 0-15.
    ///   - data1: First data byte. Usually a key number (note or controller). Between 0-127.
    ///   - data2: Second data bytes. Usually a value (pressure, velocity or program number). Between 0-127.

    /// Initializes new message automatically by parsing an array of bytes (usually from a MIDI packet).
    /// - Parameters:
    ///   - bytes: Array of bytes. At least three bytes must be supplied to create strongly-typed
    ///   MIDI message.
    public init?(bytes: [UInt8]) {
        guard bytes.count >= 2, let status = Status(rawValue: bytes[0] & 0xF0) else {
            return nil
        }
        
        let channel: UInt8 = bytes[0] & 0x0F
        let data1: UInt8 = bytes.count > 1 ? bytes[1] : 0
        let data2: UInt8 = bytes.count > 2 ? bytes[2] : 0
        
        switch status {
        case .noteOff:
            self = .noteOff(Note(channel: channel, noteNumber: data1, velocity: data2))
        case .noteOn:
            self = .noteOn(Note(channel: channel, noteNumber: data1, velocity: data2))
        case .aftertouch:
            self = .afterTouch(PolyphonicAftertouch(channel: channel, noteNumber: data1, pressure: data2))
        case .controlChange:
            self = .controlChange(ControlChange(channel: channel, control: UInt7(data1), controlValue: data2))
        case .programChange:
            self = .programChange(ProgramChange(channel: channel, program: data1))
        case .channelPressure:
            self = .channelPressure(ChannelAftertouch(channel: channel, pressureValue: data1))
        case .pitchBendChange:
            self = .pitchBendChange(PitchBend(channel: channel, lsb: data1, msb: data2))
        case .tuneRequest:
            self = .tuneRequest
        case .timingClock:
            self = .timingClock
        case .start:
            self = .start
        case .continue:
            self = .continue
        case .stop:
            self = .stop
        case .activeSensing:
            self = .activeSensing
        case .systemReset:
            self = .systemReset
        }
    }
}
