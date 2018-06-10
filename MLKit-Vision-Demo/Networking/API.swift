import Foundation
import Moya

enum API {

    //Flickr
    case photosSearch(text: String, page: Int)
}

extension API: TargetType {
    var headers: [String: String]? {
        return nil
    }

    var baseURL: URL {
        return Config.API.BaseURL
    }

    var path: String {
        switch self {
        case .photosSearch: return "services/rest/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .photosSearch:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case let .photosSearch(text, page):
            let parameters = [
                "method": "flickr.photos.search",
                "api_key": Config.Flickr.APIKey,
                "tags": text,
                "per_page": "30",
                "format": "json",
                "nojsoncallback": String("1"),
                "page": String(page)
            ]

            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }

    var shouldStub: Bool {
        switch self {
        default:
            return Config.API.StubRequests
        }
    }

    var sampleData: Data {
        switch self {
        default:
            return Data()
        }
    }

    // Load stub data
    fileprivate func stub(_ name: String) -> Data {
        let path = Bundle(for: APIClient.self).path(forResource: name, ofType: "json")!
        return (try! Data(contentsOf: URL(fileURLWithPath: path)))
    }
}
