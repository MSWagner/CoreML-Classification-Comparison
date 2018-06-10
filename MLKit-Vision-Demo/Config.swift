import Foundation

/// Global set of configuration values for this application.
struct Config {
    static let keyPrefix = "mws.mlkit-vision-demp"

    // MARK: API

    struct API {
        static var BaseURL: URL {
            switch Environment.current() {
            case .debug:
                return URL(string: "https://")!
            case .release:
                return URL(string: "https://")!
            }
        }

        static let RandomStubRequests = false
        static let StubRequests = true
        static var TimeoutInterval: TimeInterval = 120.0

        static var NetworkLoggingEnabled: Bool {
            switch Environment.current() {
            case .debug:
                return true
            case .release:
                return false
            }
        }

        static var VerboseNetworkLogging: Bool {
            switch Environment.current() {
            case .debug:
                return true
            case .release:
                return false
            }
        }
    }

    // MARK: User Defaults

    struct UserDefaultsKey {
        static let lastUpdate = Config.keyPrefix + ".lastUpdate"
    }
}
