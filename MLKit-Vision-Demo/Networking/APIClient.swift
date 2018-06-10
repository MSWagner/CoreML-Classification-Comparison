import Foundation
import Moya
import ReactiveSwift
import Result
import Moya

final class APIClient {

    // MARK: Moya Configuration

    private static let endpointClosure = { (target: API) -> Endpoint in
        let url = target.baseURL.appendingPathComponent(target.path).absoluteString

        var endpoint = Endpoint(url: url,
                                sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                                method: target.method,
                                task: target.task,
                                httpHeaderFields: target.headers)

        return endpoint
    }

    private static let stubClosure = { (target: API) -> StubBehavior in
        if target.shouldStub {
            return .delayed(seconds: 1.0)
        }
        return .never
    }

    private static var provider: MoyaProvider<API> = {
        let plugins: [PluginType] = {
            guard Config.API.NetworkLoggingEnabled else { return [] }
            let loggerPlugin = MoyaLoggerPlugin(verbose: Config.API.NetworkLoggingEnabled)
            return [loggerPlugin]
        }()

        return MoyaProvider(endpointClosure: endpointClosure, stubClosure: stubClosure, plugins: plugins)
    }()

    // MARK: Request

    /// Performs the request on the given `target`
    static func request(_ target: API) -> SignalProducer<Moya.Response, APIError> {
        return request(target, authenticated: true)
            .filterSuccessfulStatusAndRedirectCodes()
            .mapError { APIError.moya($0, target) }
    }

    /// Performs the request on the given `target` and maps the respsonse to the specific type (using Decodable).
    static func request<T: Decodable>(_ target: API, type: T.Type, keyPath: String? = nil, decoder: JSONDecoder = Decoders.standardJSON) -> SignalProducer<T, APIError> {
        return request(target, authenticated: true)
            .filterSuccessfulStatusAndRedirectCodes()
            .map(type, atKeyPath: keyPath, using: decoder)
            .mapError { APIError.moya($0, target) }
    }

    /**
     creates a new request

     - parameter target:        API target

     - returns: SignalProducer, representing task
     */
    private static func request(_ target: API, authenticated: Bool = true) -> SignalProducer<Moya.Response, MoyaError> {
        // setup initial request
        let initialRequest: SignalProducer<Moya.Response, MoyaError> = provider
            .reactive
            .request(target)
            .filterSuccessfulStatusAndRedirectCodes()

        return initialRequest
    }

    private static func unwrapUnderlyingError(error: MoyaError) -> NSError? {
        switch error {
        case let .objectMapping(error, _):
            return error as NSError
        case let .encodableMapping(error):
            return error as NSError
        case let .underlying(error, _):
            return error as NSError
        case let .parameterEncoding(error):
            return error as NSError
        default:
            return nil
        }
    }
}
