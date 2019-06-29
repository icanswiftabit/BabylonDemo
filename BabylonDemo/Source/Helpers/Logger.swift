import Foundation


struct Logger {
    static func debug(_ msg: String) {
        #if DEBUG
        print(msg)
        #endif
    }
}
