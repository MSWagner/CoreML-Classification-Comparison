import Foundation
import Moya

enum APIError: Swift.Error, LocalizedError {

    case moya(MoyaError, API)
    case underlying(Swift.Error)
    case invalidCredentials
    case setFireStoreData
    case other

    var errorDescription: String? {
        switch self {
        case let .moya(error, target):
            return localizedMoyaError(error: error, target: target)
        case .underlying:
            return APIError.defaultLocalizedError
        case .setFireStoreData:
            return Strings.Network.errorFirestoreSetData
        default:
            return APIError.defaultLocalizedError
        }
    }

    var statusCode: Int? {
        switch self {
        case let .moya(error, _):
            switch error {
            case let .statusCode(response):
                return response.statusCode
            case let .underlying(error):
                let nsError = error.0 as NSError
                return nsError.code
            default:
                return nil
            }

        case let .underlying(error):
            let nsError = error as NSError
            return nsError.code
        default:
            return nil
        }
    }

    // MARK: Helper

    private func localizedMoyaError(error: MoyaError, target: API) -> String {
        switch error {
        case let .statusCode(response):
            return localizedMoyaError(statusCode: response.statusCode, target: target)
        case let .underlying(error):
            let nsError = error.0 as NSError
            if nsError.code == -1009 || nsError.code == -1005 {
                return Strings.Network.errorNoConnection
            } else {
                return APIError.defaultLocalizedError
            }
        default:
            return APIError.defaultLocalizedError
        }
    }

    private func localizedMoyaError(statusCode: Int, target: API) -> String {
        switch (target, statusCode) {
        default:
            if target.method == .get {
                return String(format: Strings.Network.errorLoadingFailed, "\(statusCode)")
            }
            return String(format: Strings.Network.errorPostingFailed, "\(statusCode)")
        }
    }

    private static var defaultLocalizedError = Strings.Network.errorGeneric
}
