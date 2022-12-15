import Foundation
import struct os.Logger

final class AppLogger: NSObject {
    private static let shared = AppLogger(systemLogger: Logger())
    
    let systemLogger: Logger
    let enabled = true
    
    init(systemLogger: Logger) {
        self.systemLogger = systemLogger
        super.init()
    }
    
    enum Log {
        case trace(text: String)
        case info(text: String)
        case critical(text: String)
    }
    
    func log(_ log: Log) {
        guard enabled else { return }
        print(log)
        switch log {
        case .trace(text: let text):
            systemLogger.trace("\(text)")

        case .critical(text: let text):
            systemLogger.critical("\(text)")
            
        case .info(text: let text):
            systemLogger.info("\(text)")
        }
    }
    
    
    class func logTrace(_ text: String, function: StaticString = #function, prefix: String = "BOB:") {
        Self.shared.log(.trace(text: prefix + "\(function)" + text))
    }
    
    
    class func logInfo(_ text: String, function: StaticString = #function, prefix: String = "BOB:") {
        Self.shared.log(.info(text: prefix + "\(function)" + text))
    }

    
    class func logCritical(_ text: String, function: StaticString = #function, prefix: String = "BOB:") {
        Self.shared.log(.critical(text: prefix + "\(function)" + text))
    }
}
