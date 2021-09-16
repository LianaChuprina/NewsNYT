//
//  APIRouter.swift
//  test
//
//  Created by Лиана Чуприна on 26.08.2021.
//

import Foundation
import Moya

public enum Articles {
    static private let publicKey = "1QDLOprYV8YSaPevYxhQviIGhHjr7N5G"
    case emailed
    case shared
    case viewed
}

extension Articles: TargetType {
    
    public var baseURL: URL {
        return URL(string: "https://api.nytimes.com/svc/mostpopular/v2")!
    }
    
    public var path: String {
        switch self {
        case .emailed: return "/emailed/30.json"
        case .shared: return "/shared/30/facebook.json"
        case .viewed: return "/viewed/30.json"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .emailed,
             .shared,
             .viewed: return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        return .requestParameters(parameters: parameters!,
                                  encoding: parameterEncoding)
    }
    
    public var headers: [String: String]? {
        return ["application":"json"]
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    public var parameters: [String: Any]? {
        ["api-key":Articles.publicKey]
    }
}
